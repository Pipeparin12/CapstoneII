import express from "express";
import Order from '../models/order';
const orderRoute = express.Router();

export async function addOrderFunc(orderDetail: AddOrderRequestProp) {

        console.log("click");
        
        const newOrder = await Order.create(
            orderDetail
        )
        return newOrder;
}

export type AddOrderRequestProp = {
    owner: string,
    products: Array<string>,
    totalPrice: number,
    shippingInformation: {
        firstName: string,
        lastName: string,
        phone: string,
        address: string
    },
    paymentInformation: {
        slip: string,
    },
    status: {
        status: string;
        description: string | null;
    }
};

type UpdateOrderStatusRequestProp = {
    orderId: string,
    status: {
        status: string,
        description: string
    }
}

orderRoute.get('/all/', async (req, res) => {
    try {
        const orders = await Order.find();
        console.log(orders);
        return res.json({
            success: true,
            orders
        })
    } catch (error) {
        return res.json({
            success: false,
            message: error
        })
    }
});

orderRoute.get('/get-order/:orderId', async (req, res) => {
    const orderId = req.params.orderId; // Extract the order ID from the request parameters
  
    try {
      const order = await Order.findById(orderId).populate("products");
      console.log(order.products)

      if (order) {
        return res.json({
          success: true,
          order
        });
      } else {
        return res.status(404).json({
          success: false,
          message: 'Order not found'
        });
      }
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

orderRoute.post('/add-order', async (req, res) => {
    var orderDetail: AddOrderRequestProp = { ...req.body };
    console.log(orderDetail);
    try {
        const newOrder = await addOrderFunc(orderDetail);
        console.log(newOrder)
        return res.json({
            success: true,
            newOrder
        })
    } catch (error) {
        
        return res.json({
            success: false,
            message: error
        })
    }
});

orderRoute.patch('/update-status/', async (req, res) => {
    const updateDetail: UpdateOrderStatusRequestProp = req.body;
    try {
        const updateOrder = await Order.findOneAndUpdate({
            _id: updateDetail.orderId
        }, {
            status: updateDetail.status
        }
        );
        return res.json({
            success: true,
            updateOrder
        });
    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
})

orderRoute.delete('/remove/', async (req, res) => {
    const orderId = req.body.orderId;
    try {
        const removeOrder = await Order.findOneAndRemove({
            _id: orderId
        });
        return res.json({
            success: true,
            removeOrder
        });
    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
});



export default orderRoute;