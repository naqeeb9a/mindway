const admin = require('firebase-admin');
const functions = require('firebase-functions');

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

// Cloud Function to send notifications
exports.sendNotifications = functions.pubsub
  .schedule('every 1 minutes') // Schedule the function to run every minute
  .timeZone('Your_Time_Zone')
  .onRun(async (context) => {
    try {
      // Fetch user tokens from Firestore
      const usersSnapshot = await db.collection('users').get();
      const userTokens = [];
      
      usersSnapshot.forEach((userDoc) => {
        const userData = userDoc.data();
        if (userData.notificationToken) {
          userTokens.push(userData.notificationToken);
        }
      });

      // Send notifications to each user
      const message = {
        data: {
          title: 'Your Notification Title',
          body: 'Your Notification Body',
        },
      };

      const response = await admin.messaging().sendToDevice(userTokens, message);
      
      console.log('Notifications sent:', response.successCount);
      return null;
    } catch (error) {
      console.error('Error sending notifications:', error);
      return null;
    }
  });
