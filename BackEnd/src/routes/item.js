let express = require('express')
let router = express.Router()
let mongoose = require('mongoose')
let itemmodel = require('../model/item.model')

 router.get('/', (req, res, next)=> {
   // const userId = req.session._id
//find({usermodel: userId})
    itemmodel.find()
        .exec()
       .then(item => {
            res.status(200).send(item)
           console.log("Printed ALL")
        })
})

router.post('/', (req, res, next) => {
    if (!req.body){ //check that body not empty
        return res.status(400).send('body is missing')
    }
    let item = new itemmodel({
        _id: new mongoose.Types.ObjectId(),
        name: req.body.name,
        desc: req.body.desc,
        weight: req.body.weight,
        dimen: req.body.dimen,
        seller: req.body.seller,
        tag: req.body.tag,
        zip: req.body.zip
    })
    item.save() // actually save the user into DB
        .then(result => {
            console.log(result)
            res.status(201).json({
                message: 'Item created'
            })
        })
})

router.get('/:itemId', (req, res, next) => {
    let id = req.params.itemId
    if (id === 'test') {
        res.status(200).json({
            message: 'Successful TEST'
        })
    } else {
        res.status(200).json({
            message: 'Successful GET'
        })
    }
})

router.patch('/:itemId', (req, res, next)=> {
    res.status(200).json({
        message: 'Temp for PATCH for  /item/itemId'
    })
});
router.delete('/:itemId', (req, res, next)=> {
    itemmodel.remove({_id: req.params.itemId})
        .exec()
        .then(request => {
            res.status(200).json({
                message: 'Item deleted'
            })
        })
        .catch(err => {
            console.log(err)
            res.status(500).json({
                error: err
            })
        })
});


module.exports = router
//item.tag.push(req.body.tag)// push the tag into the array
