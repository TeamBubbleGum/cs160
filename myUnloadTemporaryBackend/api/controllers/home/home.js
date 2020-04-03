module.exports = async function (req, res) {
  console.log("This route shows home page of posts")
  const allItems = await Item.find()

  res.view('pages/home.ejs',
    {allItems}
  )
}





