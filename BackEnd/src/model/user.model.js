let  mongoose = require('mongoose')

let userSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectID,
    email:{type: String, required: true, unique: true},
    password: {type: String, required: true}
})

module.exports = mongoose.model('User', userSchema)

//for email could add match for email address validation
// match: /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/