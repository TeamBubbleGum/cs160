let express = require('express')
let router = express.Router()
let mongoose = require('mongoose')
let bcrypt = require('bcrypt')
let usermodel = require('../model/user.model')


// if the request from the frontend is post /user/signup
//then it picks up the code below here

// /user/signup
router.post('/signup', (req, res, next) => {
    if (!req.body){ //check that body not empty //check if body is empty
        return res.status(400).send('body is missing') //400 is error code
    }
//check if user exists
    usermodel.find({email: req.body.email}) //find function returns array
        .exec()
        .then(user => { //user is object to hold the result (it's Json object)
            if (user.length >= 1){ //already have email in DB
                return res.status(409).json({ //409 exists
                    message: 'User id: ' + user[0]._id // get ID
                })
            }
            //sign up cuz not exist (new user)
            else { //has password and add
                bcrypt.hash(req.body.password, 10,(err, hash)=>{
                    if(err) {
                        return res.status(500).json({
                            error:err
                        })
                    } else {
                        //create user with hashed password
                        let user = new usermodel({
                            _id: new mongoose.Types.ObjectId(),
                            email: req.body.email,
                            password: hash
                        })
                        //save into the DB
                        user.save() // actually save the user into DB
                            .then(result => {
                                console.log(result)
                                res.status(201).json({
                                    message: 'User created'
                                })
                            })
                            .catch(err => {
                                console.log(err)
                                res.status(500).json({
                                    error: err
                                })
                            })
                    }
                })
            }
        })
})

// /user/login
router.post('/login', (req, res, next) => {
        usermodel.find({email: req.body.email})
            .exec()
            .then(user => {
                if(user.length < 1) {
                    return res.status(404).json({  //failed
                        message: 'Auth failed'
                    })
                }
                bcrypt.compare(req.body.password, user[0].password, (err,result) => {//pwd argument in DB
                    if (err) {
                        return res.status(404).json({  //failed
                            message: 'Auth failed'
                        })
                    }
                    if (result) {
                        return res.status(200).json({
                            message: 'Auth successful'
                        })
                    }
                    res.status(401).json({
                        message: 'Auth failed'
                    })
                })
            })
            .catch(err => {
                console.log(err)
                res.status(500).json({
                    error: err
                })
            });
    }
);

// delete an account without searching yet
router.delete('/:userId', (req, res, next)=>{
    usermodel.remove({_id: req.params.userId})
        .exec()
        .then(request => {
            res.status(200).json({
                message: 'User deleted'
            })
        })
        .catch(err => {
            console.log(err)
            res.status(500).json({
                error: err
            })
        })
})

module.exports = router
