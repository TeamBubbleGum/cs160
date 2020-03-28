let express = require('express')
let app = express()
let  mongoose = require('mongoose')
//let testRoute = require('./routes/test')
let userRoute = require('./routes/user')
let bodyParser = require('body-parser')
const user = 'general_user'
const password = 'SimplyP9'



app.use(bodyParser.json())
//middlewear to log every request that comes in.
app.use((req, res, next) => {
    console.log(`${new Date().toString()} => ${req.orginalUrl}`, req.body)
    next()
})

//app.use(testRoute)
app.use('/user', userRoute)
//error 404 handler
app.use((req, res, next)=> {
    res.status(404).send('We think you are lost')
})
//error 505

//server if we want
const PORT = process.env.PORT || 3000
mongoose.connect(`mongodb://${user}:${password}@ds061076.mlab.com:61076/heroku_h8ppn5jl`,{useNewUrlParser: true})
app.listen(PORT, () => console.info(`Server has started on ${PORT}`))

//routes infor @ 25 min point of video