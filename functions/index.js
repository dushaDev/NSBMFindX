const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const vision = require('@google-cloud/vision');
const client = new vision.ImageAnnotatorClient();

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
