module.exports = {  //kind of a dictionary object
  //you want to declare your endpoint of items
items: async function (req, res) {  //request and response

  //or we can do it by using Sails API
  try{
    const items = await Item.find()
    res.send(items)
  }catch(err){
    res.serverError(err.toString())
  }
},

  create: async function(req, res){

  const title = req.body.title //in order to access to body obj of your entire request
  const itemBody = req.body.itemBody   //body is what we declared
    if(title === "" && itemBody === ""){
      console.log("Empty String");
      //res.send("Empty String")
      return res.redirect('/home')
    }

sails.log.debug('My title ' + title);
sails.log.debug('My body ' + itemBody)

  /*  const items = await Item.find()
    const filteredItems = items
      .filter(p => {return p.id == Item})*/

    //res.send("We have added an item : " + filteredItems[0])

Item.create({title: title, body: itemBody}).exec(function (err) {
  if(err){
    return res.serverError(err.toString())
  }
  console.log("Finished creating post object");
  return res.redirect('/home') //instead of going to new page
  //return res.end()
})
  },

  findById: function (req, res) {
    const itemId = req.param('itemId')
    console.log("id is :  " + itemId)
    const filteredItems = allItems
      .filter(p => {return p.id == itemId})  //declare 'p' as one of the item object inside the item array

 if(filteredItems.length >0){   //if it is greater we have found the item
   res.send(filteredItems[0])
 }else{
   res.send('Failed to find post by id: ' + itemId)
 }

  },

  delete: async function (req, res) {
  const itemId = req.param('itemId')

   await Item.destroy({id: itemId})

  res.send('Finished deleting item')
  }
}










/*const newItems = {id: 4,
  title: title,
  body: itemBody}
allItems.push(newItems)   //push() is same as append*/

//  sails.log.warn(title + " " + body)
//Or could be written as
// const filteredItems = allItems
// .filter(function(p) {
// return p.id == itemId})

//method without API
//Item.find().exec(function(err, items) {  //fetch all the objects
// if(err){
//  return res.serverError(err.toString())
//}
//res.send(items)  //sending the items back
//   })
