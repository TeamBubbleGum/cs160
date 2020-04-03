let express = require('express')
let app = express()
let  mongoose = require('mongoose')
let userRoute = require('./routes/user')
let itemRoute = require('./routes/item')
let bodyParser = require('body-parser')
const user = 'general_user'
const password = 'SimplyP9'

mongoose.connect(`mongodb://${user}:${password}@ds061076.mlab.com:61076/heroku_h8ppn5jl`,{useNewUrlParser: true})


app.use(bodyParser.json())// parse into json
//middlewear to log every request that comes in.
app.use((req, res, next) => {
    console.log(`${new Date().toString()} => ${req.orginalUrl}`, req.body)
    next()
})

//ROUTES
app.use('/user', userRoute)
app.use('/item', itemRoute)

//error 404 handler
app.use((req, res, next)=> {
    res.status(404).send('We think you are lost')
})
//error 505

//server if we want
const PORT = process.env.PORT || 3000
app.listen(PORT, () => console.info(`Server has started on ${PORT}`))

//routes infor @ 25 min point of video