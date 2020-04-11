
module.exports = {


  friendlyName: 'Create',


  description: 'Create item.',


  inputs: {
  title: {
    description: 'Tittle of item object',
    type: 'string',
    required: true
   },
    itemBody: {
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
    }
  },


  exits: {

  },


  fn: async function (inputs) {

    // All done.
    console.log('Inside item/create action')

    const userId = this.req.session.userId

    console.log(userId)
    console.log(this.req.me);
    const response = await Item.create({title: inputs.title, body: inputs.itemBody, weight: inputs.weight,
    user: userId}).fetch()
    console.log(response.id);

    this.res.redirect('/home')
    //return;

  }


};
