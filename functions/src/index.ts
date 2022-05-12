/* eslint-disable no-alert */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { MulticastMessage } from 'firebase-admin/lib/messaging/messaging-api';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

const USER_TOKEN_DB_NAME = 'userToken-dev';
const ACTIVITY_SETUP_RECORD_DB_NAME = 'activitySetupRecord-dev';
if (!admin.apps.length) {
  admin.initializeApp();
}

export const sendUserActivitySetupMessage = functions.pubsub.schedule('0 8-23 * * *').onRun(
  async (context) => {
    try {
      functions.logger.info({
        method: 'sendUserActivitySetupMessage - start'
      });

      const userTokenDbColection = admin
        .firestore()
        .collection(USER_TOKEN_DB_NAME);

      const activitySetupRecordCollection = admin
        .firestore()
        .collection(ACTIVITY_SETUP_RECORD_DB_NAME);

      // Getting all the users
      const registeredUsers = await userTokenDbColection.get();
      const userIdTokenMappings: any = {};

      // Creating a mapping of user id to their registration token
      registeredUsers.forEach((user) => {
        const userId = user.id;
        if (userId != 'hashedEmail') {
          userIdTokenMappings[`${userId}`] = user.data()['token'];
        }
      });

      const tokensToBeSent: any = [];

      // console.log(JSON.stringify(userIdTokenMappings));
      functions.logger.info({ 
        method: 'sendUserActivitySetupMessage',
        userIdTokenMappings: userIdTokenMappings 
      });

      // Parsing current date to appropriate parameter
      const date = new Date().toLocaleDateString().split('/');
      if (parseInt(date[0], 10) < 10) {
        date[0] = '0' + date[0];
      }
      if (parseInt(date[1], 10) < 10) {
        date[1] = '0' + date[1];
      }
      const convertedDate = date[0] + '-' + date[1] + '-' + date[2].substr(2, 4);
      
      functions.logger.info({ 
        method: 'sendUserActivitySetupMessage',
        convertedDate: convertedDate 
      });

      const activitySetupRecord = await activitySetupRecordCollection.doc(convertedDate).get();

      // No activity record exist => send notification message to all users
      if (!activitySetupRecord.exists) {
        functions.logger.info({ msg: 'no participant setup activity yet' });
        Object.keys(userIdTokenMappings).forEach((userId) => {
          tokensToBeSent.push(userIdTokenMappings[userId]);
        });
      } else {
        // Some users have completed their activity setup for the day
        const completedIds = new Set(
          activitySetupRecord.data()!!['completedIds']
        );
        functions.logger.info({
          completedIds: new Array(...completedIds).join(' '),
        });

        Object.keys(userIdTokenMappings).forEach((userId) => {
          if (!completedIds.has(userId) && userId != 'hashedEmail') {
            // User have not setup their activity for the day yet
            tokensToBeSent.push(userIdTokenMappings[userId]);
          }
        });

        functions.logger.info({
          method: 'SendUserActivitySetupMessage',
          tokensToBeSent: JSON.stringify(tokensToBeSent),
        });
      }
      await sendMessage(tokensToBeSent);
      functions.logger.info({
        method: 'SendUserActivitySetupMessage',
        status: 'success'
      })
    } catch (error) {
      console.log(error);
      functions.logger.info({ method: 'SendUserActivitySetupMessage', error: error });
    }
  }
);

async function sendMessage(tokenArrays: string[]) {
  const message: MulticastMessage = {
    notification: {
      body: 'This is a reminder to setup your activity for the day',
      title: 'Activity Setup Reminder',
    },
    tokens: tokenArrays,
  };
  await admin.messaging().sendMulticast(message);
}
