const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();

exports.sendNotification = functions.pubsub
    .schedule("0 * * * *") // every 1 hours
    // .timeZone('Asia/Sydney')
    .onRun(async(context) => {
        const user = database.collection("users");

        const querySnapshot = await user.get();

        const currentDate = new Date();

        querySnapshot.forEach(async(doc) => {
            const token = doc.data().token;

            const dayOfWeek = currentDate.toLocaleString("en-US", {
                weekday: "short",
            });
            if (doc.data().days.includes(dayOfWeek)) {
                console.log(`Found ${JSON.stringify(doc.data())}`);
                const date = doc.data().time.toDate();

                const year = date.getFullYear();
                const month = date.getMonth();
                const day = date.getDate();

                const startTime = new Date(
                    year,
                    month,
                    day,
                    currentDate.getHours(),
                    currentDate.getMinutes(),
                    currentDate.getSeconds()
                );

                const endTime = new Date(
                    year,
                    month,
                    day,
                    currentDate.getHours() + 1,
                    currentDate.getMinutes(),
                    currentDate.getSeconds()
                );

                console.log(`startTime test 3 ${startTime}`);
                console.log(`Database date test 3 ${date}`);
                console.log(`endTime test 3 ${endTime}`);
                if (date >= startTime && date <= endTime) {
                    console.log("Sending notification test 3...");
                    const message = {
                        notification: {
                            title: "Mindway",
                            body: "Hey, testing!",
                        },
                        data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
                    };

                    await admin
                        .messaging()
                        .sendToDevice(token, message)
                        .then((response) => {
                            return console.log(`Successful Message Sent to token: ${token}`);
                        })
                        .catch((error) => {
                            return console.log(
                                `Error Sending Message to token: ${token}` + error
                            );
                        });
                } else {
                    console.log("Current time is outside notification window test 3");
                }
            } else {
                console.log(`Not found`);
            }
        });
        return console.log("End Of Function");
    });