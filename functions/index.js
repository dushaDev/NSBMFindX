const functions = require('firebase-functions');
const vision = require('@google-cloud/vision');
const { GoogleGenerativeAI, TaskType } = require('@google/generative-ai');
const client = new vision.ImageAnnotatorClient();
require('dotenv').config({ path: __dirname + '/.env' });
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

exports.simpleGenAIEmbeddingTest = functions.https.onCall(
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
