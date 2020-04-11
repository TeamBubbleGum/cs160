
module.exports = {
  attributes : {
    title :{
      type: 'string',
      required: true
    },
    body:{
      type: 'string',
      required: true
    },
    weight: {
      type: 'string'
      //match: /([\d.]+)\s+(lbs?|oz|g|kg) /
       },
    dimensions: {
      type: 'string'
     // match: /(\d+(?:,\d+)?) x (\d+(?:,\d+)?)(?: x (\d+(?:,\d+)?))?/
      },
    //seller: {type: mongoose.Schema.Types.ObjectID}, //require seller's ID
    //tag: [String], //array of strings for tags
    zip: {
      type: 'string'
      //match: /^(\d{5}(?:\-\d{4})?)$/
    },
    user : {
    model: 'user'
    }
  }
}
