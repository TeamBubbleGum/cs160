let express = require('express')
let router = express.Router()
let mongoose = require('mongoose')
let bcrypt = require('bcrypt')
let usermodel = require('../model/user.model')


router.post('/signup', (req, res, next) => {
    if (!req.body){ //check for body
        return res.status(400).send('body is missing')
    }
//check if user exists
    usermodel.find({email: req.body.email})
        .exec()
        .then(user => {
            if (user.length >= 1){ //already have email in DB
                return res.status(409).json({
                    message: 'Email exists'
                })
            } else{ //has password and add
                bcrypt.hash(req.body.password, 10,(err, hash)=>{
                    if(err)
                    {
                        return res.status(500).json({
                            error:err
                        })
                    } else
                    {
                        //create user with hashed password
                        let user = new usermodel({
                            _id: new mongoose.Types.ObjectId(),
                            email: req.body.email,
                            password: hash
                        })
                        user
                            .save()
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

router.delete('/:userId', (req, res, next)=>{
    usermodel.remove({_id: req.params.id})
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