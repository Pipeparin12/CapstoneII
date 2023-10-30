import express from "express";
import Bookmark from '../models/bookmark';
import Product from '../models/product';
const bookmarkRoute = express.Router();

bookmarkRoute.post('/add-bookmark/:id', async (req,res) => {
      const user_id = req.user.user_id;
      if (!req.user) {
          return res.status(401).json({
              success: false,
              message: 'User not authenticated.'
          });
      }
  
      try {
          const product_id = req.params.id;

          const product = await Product.findById(product_id);
          console.log(product)
  
          await Bookmark.create({
              'owner': user_id,
              "productId": product_id,
              'productImage': product.productImage,
          });
          return res.json({
              success: true,
              message: 'Added bookmark successfully'
          })
      } catch (err) {
          return res.json({
              success: false,
              message: err
          })
      }
})

bookmarkRoute.get('/get-bookmark', async (req,res) => {
    try {
        const user = await req.user.user_id;       
        const bookmark = await Bookmark.find({ 'owner': user}).exec();
        const product = await Product.find({_id: {$in: bookmark.map((e) => e.productId)}}).exec();

        let serializedBookmark = JSON.parse(JSON.stringify(bookmark));
        let serializedProduct = JSON.parse(JSON.stringify(product));

        // console.log(JSON.stringify(book), JSON.stringify(bookmark))
        const bookmarks = serializedBookmark.map(bm => ({ ...bm, product: serializedProduct.find(b => b._id === bm.productId)}));
        return res.json({
            bookmarks,
            success: true,
            message: 'Get bookmark successfully!'
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
})

bookmarkRoute.delete('/unbookmark/:id', async (req,res) => {
    try {
        const bookmark = await Bookmark.findByIdAndDelete(req.params.id);
        console.log(bookmark);
        return res.json({
            success: true,
            message: 'Delete bookmark successfully'
        })
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})

export default bookmarkRoute;