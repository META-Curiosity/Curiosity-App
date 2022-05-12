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
      functions.logger.info('sendUserActivitySetupMessage');
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
      functions.logger.info({ userIdTokenMappings: userIdTokenMappings });

      // Parsing current date to appropriate parameter
      const date = new Date().toISOString().split('T')[0].split('-');
      const convertedDate =
        date[1] + '-' + date[2] + '-' + date[0].substr(2, 4);

      const activitySetupRecord = await activitySetupRecordCollection
        .doc(convertedDate)
        .get();

      // No activity record exist => send notification message to all users
      if (!activitySetupRecord.exists) {
        functions.logger.info({ msg: 'no participant setup activity yet' });
        Object.keys(userIdTokenMappings).forEach((userId) => {
          tokensToBeSent.push(userIdTokenMappings[userId]);
        });
        sendMessage(tokensToBeSent);
      } else {
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
          tokensToBeSent: JSON.stringify(tokensToBeSent),
        });
        await sendMessage(tokensToBeSent);
        return console.log("success");
      }
    } catch (error) {
      console.log(error);
      functions.logger.info({ error: error });
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
