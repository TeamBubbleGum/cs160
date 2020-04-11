module.exports = async function (req, res) {
  console.log("This route shows home page of posts")


  const userId = req.session.userId
  const allItems = await Item.find({user: userId })

  if(req.wantsJSON){
    return res.send(allItems)
  }

  res.view('pages/home.ejs',
    {allItems}
  )
}





