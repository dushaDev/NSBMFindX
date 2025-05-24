const functions = require('firebase-functions');
const vision = require('@google-cloud/vision');
const { GoogleGenerativeAI, TaskType } = require('@google/generative-ai');
const client = new vision.ImageAnnotatorClient();
require('dotenv').config({ path: __dirname + '/.env' });
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();
const geminiApiKey = process.env.GEMINI_API_KEY;

// IMPORTANT: Do not deploy this code with this code. need set api
// key to 'geminiApiKey' before publish. get key from env file
// Do not push this code with the API key to a public repository.

exports.analyzeImage = functions
  .https.onCall(
    {
      enforceAppCheck: false,
    },
    async request => {
      const imageUrl = request.data.imageUrl;
      if (!imageUrl) {
        throw new functions.https.HttpsError(
          'invalid-argument',
          'The image URL is required.',
        );
      }
      try {
        const [labelResult] = await client.labelDetection(imageUrl);
        const labels =
          labelResult.labelAnnotations.map(label => label.description);
        const [objectResult] = await client.objectLocalization(imageUrl);
        const objects =
          objectResult.localizedObjectAnnotations.map(obj => obj.name);
        const [textResult] = await client.textDetection(imageUrl);
        const fullText =
          textResult.fullTextAnnotation ? textResult.fullTextAnnotation.text : '';
        return {
          status: 'success',
          labels: labels,
          objects: objects,
          fullText: fullText,
        };
      } catch (error) {
        console.error('Error analyzing image:', error);
        throw new functions.https.HttpsError(
          'internal',
          'Failed to analyze image.',
          error.message,
        );
      }
    },
  );

exports.textEmbedding = functions.https.onCall(
  {
    enforceAppCheck: false,
  },
  async request => {
    const contentToEmbed = request.data.content;
    try {
      const genAI = new GoogleGenerativeAI(geminiApiKey);
      const embeddingModel = genAI.getGenerativeModel({ model: 'text-embedding-004' });
      const response = await embeddingModel.embedContent({
        content: {
          parts: [{ text: contentToEmbed }],
        },
        taskType: TaskType.SEMANTIC_SIMILARITY,
      });

      if (response.embedding && response.embedding.values) {
        return {
          status: 'success',
          message: contentToEmbed,
          dim: response.embedding.values.length,
          values: response.embedding.values,
        };
      } else {
        console.error('ERROR: No embedding values found in GenAI response.');
        throw new functions.https.HttpsError('internal', 'Embedding data missing.');
      }
    } catch (error) {
      console.error('ERROR in simpleGenAIEmbeddingTest:', error);

      let errorMessage = `Failed to get embedding: ${error.message || 'Unknown error'}`;
      let errorCode = 'internal';

      if (error.code && error.code === 429) {
        errorMessage = 'Quota exceeded for GenAI embeddings. Check your Google Cloud quotas.';
        errorCode = 'resource-exhausted';
      }

      throw new functions.https.HttpsError(errorCode, errorMessage);
    }
  });

/**
 * Calculates the cosine similarity between two vectors.
 * Assumes vectors are already normalized (unit vectors).
 * @param {number[]} vec1 - The first vector
 * @param {number[]} vec2 - The second vector
 * @return {number} Cosine similarity
 */
function calculateCosineSimilarity(vec1, vec2) {
  if (!vec1 || !vec2 || vec1.length === 0 || vec2.length === 0 || vec1.length !== vec2.length) {
    // Handle cases where an embedding might be missing or invalid
    return 0; // No similarity for invalid/empty vectors
  }
  let dotProduct = 0;
  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i] * vec2[i];
  }
  return dotProduct;
}

/**
 * Gets all relevant embeddings from an Embeddings document.
 * @param {object} embeddingsDocData
 * @return {number[]} An array of embeddings
 */
function getAllEmbeddingsFromDoc(embeddingsDocData) {
  const embeddings = [];
  if (embeddingsDocData['0'] && Array.isArray(embeddingsDocData['0']) && embeddingsDocData['0'].length > 0) {
    embeddings.push(embeddingsDocData['0']); // textEmbedding
  }
  if (embeddingsDocData['1'] && Array.isArray(embeddingsDocData['1']) && embeddingsDocData['1'].length > 0) {
    embeddings.push(embeddingsDocData['1']); // imageEmbedding1
  }
  if (embeddingsDocData['2'] && Array.isArray(embeddingsDocData['2']) && embeddingsDocData['2'].length > 0) {
    embeddings.push(embeddingsDocData['2']); // imageEmbedding2
  }
  return embeddings;
}
/** This function for Matching lost and found Items with Oncreate 'embeddings' trigger */
exports.matchNewEmbedding = functions.firestore.onDocumentCreated(
  'embeddings/{embeddingDocId}',
  async event => {
    const snap = event.data;
    const postId = event.params.embeddingDocId;

    if (!snap) {
      console.log('No data associated with the onCreate event for embedding document.');
      return null;
    }

    const newEmbeddingData = snap.data();
    const isFoundItem = newEmbeddingData.type === true;

    console.log(`Processing new embedding for post ID: ${postId} (Type: ${isFoundItem ? 'Found' : 'Lost'})`);

    const localEmbeddings = getAllEmbeddingsFromDoc(newEmbeddingData);
    if (localEmbeddings.length === 0) {
      console.log(`Post ${postId} has no valid embeddings. Skipping matching.`);
      return null;
    }

    const matches = [];
    const SIMILARITY_THRESHOLD = 0.70;

    const remoteEmbeddingsSnapshot = await firestore.collection('embeddings')
      .where('type', '==', !newEmbeddingData.type)
      .get();

    if (remoteEmbeddingsSnapshot.empty) {
      console.log(`No remote embeddings of type ${!isFoundItem ? 'Lost' : 'Found'} found to match against.`);
      return null;
    }

    for (const remoteDoc of remoteEmbeddingsSnapshot.docs) {
      const remotePostId = remoteDoc.id;
      if (remotePostId === postId) {
        continue;
      }

      const remoteEmbeddingsData = remoteDoc.data();
      const remoteEmbeddings = getAllEmbeddingsFromDoc(remoteEmbeddingsData);

      if (remoteEmbeddings.length === 0) {
        console.log(`Remote post ${remotePostId} has no valid embeddings. Skipping comparison.`);
        continue;
      }

      let maxOverallSimilarity = 0;

      for (const localVec of localEmbeddings) {
        for (const remoteVec of remoteEmbeddings) {
          try {
            const similarity = calculateCosineSimilarity(localVec, remoteVec);
            if (similarity > maxOverallSimilarity) {
              maxOverallSimilarity = similarity;
            }
          } catch (error) {
            console.error(`Error calculating similarity between ${postId} and ${remotePostId}:`, error);
          }
        }
      }

      if (maxOverallSimilarity >= SIMILARITY_THRESHOLD) {
        matches.push({
          remotePostId: remotePostId,
          similarityScore: maxOverallSimilarity,
          matchType: 'hybrid_embedding',
        });
      }
    }

    // --- Store Matches in the Top-Level 'matches' Collection ---
    const batch = firestore.batch();

    if (matches.length > 0) {
      console.log(`Found ${matches.length} potential matches for post ${postId}.`);
      for (const match of matches) {
        const matchRef = firestore.collection('matches').doc();
        const initiatorType = isFoundItem ? true : false;
        const matchedType = !isFoundItem ? true : false;

        // Store the match data
        batch.set(matchRef, {
          item1Id: postId, // The ID of the item that initiated the match check
          item1Type: initiatorType,
          item2Id: match.remotePostId, // The ID of the item it matched against
          item2Type: matchedType,
          similarityScore: match.similarityScore,
          matchType: match.matchType,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          status: 'pending', // Initial status for a new match //not used yet
        });

        const localPostDocRef = firestore.collection(isFoundItem ? 'foundItems' : 'lostItems').doc(postId);
        const remotePostDocRef = firestore
          .collection(isFoundItem ? 'lostItems' : 'foundItems').doc(match.remotePostId);

        batch.update(localPostDocRef, {
          hasMatches: admin.firestore.FieldValue.increment(1),
        }, { merge: true });

        batch.update(remotePostDocRef, {
          hasMatches: admin.firestore.FieldValue.increment(1),
        }, { merge: true });
      }
      try {
        await batch.commit(); // This is where you await and catch the error for the *entire batch*
        console.log(`Batch commit successful for post ${postId}.`);
      } catch (batchErr) {
        console.error(`FATAL: Error during batch commit for post ${postId}:`, batchErr);

        throw new functions.https.HttpsError('internal', 'Firestore batch commit failed.', batchErr.message);
      }
    } else {
      console.log(`No matches found for post: ${postId}.`);
    }

    return null;
  },
);

/**
 * Helper function to retrieve item data from 'lostItems' or 'foundItems' collections
 * @param {string} collectionName 'lostItems' or 'foundItems'
 * @param {string} itemId
 * @return {Promise<object|null>} item document data
 */
async function getItemData(collectionName, itemId) {
  try {
    /**
    @param {string} collectionName 'lostItems' or 'foundItems'
    @param {string} itemId
    @return { id: string, ...data } item document data, including its ID
     */
    const docRef = firestore.collection(collectionName).doc(itemId);
    const docSnap = await docRef.get();
    if (docSnap.exists) {
      return { id: docSnap.id, ...docSnap.data() };
    }
    console.warn(`Item document ${itemId} not found in collection ${collectionName}.`);
    return null;
  } catch (error) {
    console.error(`Error fetching item ${itemId} from ${collectionName}:`, error);
    return null;
  }
}

/** Cloud Function: sendMatchNotification with onCreate trigger for 'matches' collection */
exports.sendMatchNotification = functions.firestore.onDocumentCreated(
  'matches/{matchDocId}',
  async event => {
    const matchDocId = event.params.matchDocId;
    const matchData = event.data?.data();

    // Basic validation: ensure match data exists
    if (!matchData) {
      console.log(`No data found for match ${matchDocId}. Exiting notification function.`);
      return null;
    }

    console.log(`Starting notification process for new match ID: ${matchDocId}`);

    const { item1Id, item1Type, item2Id, item2Type } = matchData;

    const item1CollectionName = item1Type === false ? 'lostItems' : 'foundItems';
    const item2CollectionName = item2Type === false ? 'lostItems' : 'foundItems';

    // Fetch the full data for both matched items
    const item1Doc = await getItemData(item1CollectionName, item1Id);
    const item2Doc = await getItemData(item2CollectionName, item2Id);

    // Basic validation for fetched item documents
    if (!item1Doc || !item2Doc) {
      console.warn(`Could not fetch data for item1 (${item1Id} from ${item1CollectionName}) 
        or item2 (${item2Id} from ${item2CollectionName}) in match ${matchDocId}. Skipping notification creation.`);
      return null;
    }

    // Ensure both items have a 'userId' field to identify the owner
    if (!item1Doc.userId || !item2Doc.userId) {
      console.warn(`One or both items in match ${matchDocId} are missing a 'userId' field.
        Skipping notification. Item1 userId: ${item1Doc.userId}, Item2 userId: ${item2Doc.userId}`);
      return null;
    }

    const owner1Id = item1Doc.userId;
    const owner2Id = item2Doc.userId;

    // Initialize a Firestore batch for atomic notification writes
    const notificationsBatch = firestore.batch();
    const processedOwners = new Set();

    // --- Generate the custom timestamp string in Sri Lanka Time (UTC+5:30) ---
    const nowUtc = new Date(); // Get current UTC time

    // Add 5 hours and 30 minutes (330 minutes) to convert to IST
    const nowIST = new Date(nowUtc.getTime() + (5 * 60 + 30) * 60 * 1000);

    // Timestamp "2025/5/23/23/39" this for my use of app
    const year = nowIST.getFullYear();
    const month = nowIST.getMonth() + 1; // getMonth() is 0-indexed
    const day = nowIST.getDate();
    const hours = nowIST.getHours();
    const minutes = nowIST.getMinutes();

    const formattedTimestamp = `${year}/${month}/${day}/${hours}/${minutes}`;
    console.log(`Generated notification timestamp: ${formattedTimestamp}`);

    // Create notification for the owner of Item 1
    if (!processedOwners.has(owner1Id)) {
      const notification1Ref = firestore.collection('users').doc(owner1Id).collection('notifications').doc();
      const message1 = `A new match found for your ${item1Type === false ? 'lost' : 'found'} item
       '${item1Doc.itemName || item1Id}' 
      with a ${item2Type === false ? 'lost' : 'found'} item '${item2Doc.itemName || item2Id}'!`;

      notificationsBatch.set(notification1Ref, {
        userId: owner1Id,
        matchId: matchDocId,
        targetItemId: item1Id,
        targetItemType: item1Type, // Boolean (false=lost, true=found)
        matchedItemId: item2Id,
        matchedItemType: item2Type, // Boolean (false=lost, true=found)
        message: message1,
        read: false,
        timestamp: formattedTimestamp, // Stored as custom string
        notificationType: 'match', // Categorize this as a 'match' notification
      });
      processedOwners.add(owner1Id); // Mark this owner as processed
      console.log(`Prepared notification for user ${owner1Id} (owning item1).`);
    }

    // Create notification for the owner of Item 2 (only if different from owner 1)
    if (owner2Id !== owner1Id && !processedOwners.has(owner2Id)) {
      const notification2Ref = firestore.collection('users').doc(owner2Id).collection('notifications').doc();
      const message2 = `A new match found for your ${item2Type === false ? 'lost' : 'found'} 
      item '${item2Doc.itemName || item2Id}' 
      with a ${item1Type === false ? 'lost' : 'found'} item '${item1Doc.itemName || item1Id}'!`;

      notificationsBatch.set(notification2Ref, {
        userId: owner2Id,
        matchId: matchDocId,
        targetItemId: item2Id,
        targetItemType: item2Type, // Boolean (false=lost, true=found)
        matchedItemId: item1Id,
        matchedItemType: item1Type, // Boolean (false=lost, true=found)
        message: message2,
        read: false,
        timestamp: formattedTimestamp, // Stored as custom string
        notificationType: 'match', // Categorize this as a 'match' notification
      });
      processedOwners.add(owner2Id); // Mark this owner as processed
      console.log(`Prepared notification for user ${owner2Id} (owning item2).`);
    }

    try {
      await notificationsBatch.commit();
      console.log(`Notifications successfully committed for match ${matchDocId}.`);
    } catch (error) {
      console.error(`FATAL: Error committing notifications batch for match ${matchDocId}:`, error);
      throw new functions.https.HttpsError('internal', 'Failed to commit notification batch.', error.message);
    }

    return null;
  },
);
