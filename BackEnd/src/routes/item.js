let express = require('express')
let router = express.Router()
let mongoose = require('mongoose')
let itemmodel = require('../model/item.model')




router.get('/', (req, res, next)=> {
    res.status(200).json({
        message: 'Temp for GET for  /item'
    })
})

router.post('/', (req, res, next)=> {
    res.status(200).json({
        message: 'Temp for POST for  /item'
    })
})

router.get('/:itemId', (req, res, next)=> {
    const id = req.params.itemId
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