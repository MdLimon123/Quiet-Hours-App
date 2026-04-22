const admin = require("firebase-admin");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

admin.initializeApp();

exports.sendQuietRequestNotification = onDocumentCreated(
  {
    document: "quiet_requests/{requestId}",
    region: "us-central1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }

    const request = snapshot.data();
    const neighborhoodId = request.neighborhoodId;
    const senderUserId = request.userId;
    if (!neighborhoodId || !senderUserId) {
      return;
    }

    const topic = `quiet_${sanitizeTopic(neighborhoodId)}`;
    const title = "New Quiet Hours Request";
    const body =
      request.requesterName && request.reason
        ? `${request.requesterName} requested quieter surroundings for ${request.reason}.`
        : "A nearby neighbor requested quieter surroundings.";

    await admin.messaging().send({
      topic,
      data: {
        type: "quiet_request_created",
        requestId: snapshot.id,
        neighborhoodId: neighborhoodId,
        senderUserId: senderUserId,
        title,
        body,
      },
      android: {
        priority: "high",
      },
      apns: {
        headers: {
          "apns-priority": "10",
        },
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
      },
    });
  },
);

function sanitizeTopic(value) {
  return String(value).replace(/[^a-zA-Z0-9_-]/g, "");
}
