
use("assignment2");
db.campaigns.aggregate([
  {
    $lookup: {
      from: "messages",
      localField: "id",
      foreignField: "campaign_id",
      as: "messages"
    }
  },
  {
    $unwind: "$messages"
  },
  {
    $group: {
      _id: {
        campaign_id: "$id",
        campaign_type: "$campaign_type",
        channel: "$channel",
        topic: "$topic"
      },
      total_messages: { $sum: 1 },
      purchases: {
        $sum: {
          $cond: [{ $eq: ["$messages.is_purchased", true] }, 1, 0]
        }
      },
      total_sent_to_purchase_time: {
        $sum: {
          $cond: [
            { $eq: ["$messages.is_purchased", true] },
            { $divide: [{ $subtract: ["$messages.purchased_at", "$messages.sent_at"] }, 1000 * 3600] },
            0
          ]
        }
      }
    }
  },
  {
    $addFields: {
      conversion_rate: {
        $round: [
          {
            $multiply: [
              { $divide: ["$purchases", "$total_messages"] },
              100
            ]
          },
          2
        ]
      },
      avg_hours_to_purchase: {
        $round: [
          { $divide: ["$total_sent_to_purchase_time", "$purchases"] },
          2
        ]
      }
    }
  },
  {
    $match: {
      conversion_rate: { $gt: 0 }
    }
  },
  {
    $project: {
      _id: 0,
      campaign_id: "$_id.campaign_id",
      campaign_type: "$_id.campaign_type",
      channel: "$_id.channel",
      topic: "$_id.topic",
      total_messages: 1,
      purchases: 1,
      conversion_rate: 1,
      avg_hours_to_purchase: 1
    }
  },
  {
    $sort: { conversion_rate: -1 }
  }
]);