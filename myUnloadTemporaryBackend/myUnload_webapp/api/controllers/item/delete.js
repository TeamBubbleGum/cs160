module.exports = {


  friendlyName: 'Delete',


  description: 'Delete item.',


  inputs: {
    itemId: {
      type: 'string',
      required: true
    }

  },


  exits: {
invalid : {
  description: 'This was an invalid item to delete'
}
  },


  fn: async function (inputs) {
    console.log("Inside delete action");

    console.log("Trying to item with id: " +  inputs.itemId);

    const record = await Item.destroy({id: inputs.itemId}).fetch()
    console.log(record);
    if(record.length == 0){
      throw({invalid: {error: 'Record does not exist'}})
    }

    // All done.
    return record

  }


};
