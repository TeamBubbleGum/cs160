/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes tell Sails what to do each time it receives a request.
 *
 * For more information on configuring custom routes, check out:
 * https://sailsjs.com/anatomy/config/routes-js
 */

module.exports.routes = {

  /***************************************************************************
  *                                                                          *
  * Make the view located at `views/homepage.ejs` your home page.            *
  *                                                                          *
  * (Alternatively, remove this and add an `index.html` file in your         *
  * `assets` directory)                                                      *
  *                                                                          *
  ***************************************************************************/

  '/': { view: 'pages/homepage' },
  //Adding another route
  '/items': 'ItemsController.items',
  //  '/findById/:postId': 'PostsController.findById', //concept called slug
  'GET /item/:itemId': 'ItemsController.findById',
  //'POST /item': 'ItemsController.create',
  //If we want to use Sails actions then:
  'POST /item': 'item/create',
  //'DELETE /item/:itemId': 'ItemsController.delete',
  //If we want to use action file then:
  'DELETE /item/:itemId': 'item/delete',
  'GET /home': 'home/home'
  /***************************************************************************
  *                                                                          *
  * More custom routes here...                                               *
  * (See https://sailsjs.com/config/routes for examples.)                    *
  *                                                                          *
  * If a request to a URL doesn't match any of the routes in this file, it   *
  * is matched against "shadow routes" (e.g. blueprint routes).  If it does  *
  * not match any of those, it is matched against static assets.             *
  *                                                                          *
  ***************************************************************************/


};
