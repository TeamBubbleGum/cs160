let express = require('express')
let router = express.Router()
let mongoose = require('mongoose')
let itemmodel = require('../model/item.model')


router.get('/', (req, res, next)=> {
    itemmodel.find()
        .exec()
        .then(item => {
            res.status(200).json({
                list: item
            })
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
})
router.delete('/:itemId', (req, res, next)=> {
    res.status(200).json({
        message: 'Temp for DELETE for  /item/itemId'
    })
})


module.exports = router
//item.tag.push(req.body.tag)// push the tag into the array
