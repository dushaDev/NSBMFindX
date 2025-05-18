const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const vision = require('@google-cloud/vision');
const client = new vision.ImageAnnotatorClient();
const { VertexAI } = require('@google-cloud/vertexai');
const PROJECT_ID = 'find-x-727a1';
const LOCATION = 'us-central1';

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
          labels: labels,
          objects: objects,
          fullText: fullText,
          message: 'Image analysis successful.',
        };
      } catch (error) {
        console.error('Error analyzing image:', error);
        throw new functions.https.HttpsError(
          'internal',
          'Failed to analyze image.',
          error.message,
        );
      }
    });
/**
 * @param {number[]} vec1 - The first vector (array of numbers).
 * @param {number[]} vec2 - The second vector (array of numbers).
 * @return {number} The cosine similarity score, typically between 0 and 1.
 * @throws {Error} If the input vectors are not of the same length.
 */
function calculateCosineSimilarity(vec1, vec2) {
  if (vec1.length !== vec2.length) {
    throw new Error('Vectors must be of the same length.');
  }
  let dotProduct = 0;
  let magnitudeA = 0;
  let magnitudeB = 0;

  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i] * vec2[i];
    magnitudeA += vec1[i] * vec1[i];
    magnitudeB += vec2[i] * vec2[i];
  }
  magnitudeA = Math.sqrt(magnitudeA);
  magnitudeB = Math.sqrt(magnitudeB);

  if (magnitudeA === 0 || magnitudeB === 0) {
    return 0;
  }
  return dotProduct / (magnitudeA * magnitudeB);
}
/* */
exports.getSentenceSimilarity = functions.https.onCall(
  {
    enforceAppCheck: false,
  },
  async request => {
    const sentence1 = request.data.sentence1;
    const sentence2 = request.data.sentence2;

    if (!sentence1 || !sentence2) {
      throw new functions.https.HttpsError('invalid-argument', 'Both sentence1 and sentence2 are required.');
    }
    try {
      const vertexAI = new VertexAI({ project: PROJECT_ID, location: LOCATION });
      const embeddingModel = vertexAI.getGenerativeModel({
        model: 'text-embedding-004',
      });
      const getEmbedding = async text => {
        const result = await embeddingModel.embedContent({
          content: { dataType: 'text', text: text },
        });
        return result.embeddings[0].values;
      };
      const embedding1 = await getEmbedding(sentence1);
      const embedding2 = await getEmbedding(sentence2);
      const similarityScore = calculateCosineSimilarity(embedding1, embedding2);
      const similarityPercentage = (similarityScore * 100).toFixed(2);
      return {
        sentence1: sentence1,
        sentence2: sentence2,
        similarityScore: similarityScore,
        similarityPercentage: `${similarityPercentage}%`,
        message: `The two sentences are ${similarityPercentage}% semantically similar.`,
      };
    } catch (error) {
      console.error('Error in getSentenceSimilarity:', error);
      throw new functions.https.HttpsError('internal', 'Failed to calculate sentence similarity.', error.message);
    }
  },
);

