let  mongoose = require('mongoose')

let itemSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectID,
    name:{type: String, required: true},
    desc: {type: String},
    weight: {type: String, match: /([\d.]+)(lbs?|oz|g|kg)/}, // 2lbs, 1lb
    dimen: {type: String, match: /(\d+(?:,\d+)?) x (\d+(?:,\d+)?)(?: x (\d+(?:,\d+)?))?/},
    seller: {type: mongoose.Schema.Types.ObjectID}, //require seller's ID
    tag: [String], //array of strings for tags
    zip: {type: String, match: /^(\d{5}(?:\-\d{4})?)$/}
})

module.exports = mongoose.model('Item', itemSchema)
//require: true