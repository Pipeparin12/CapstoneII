import express from "express";
import Order from '../models/order';
import Product from "@/models/product";
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

type GetOrderId = {
    
}

orderRoute.get('/all', async (req, res) => {
    try {
        const userId = await req.user.user_id;
        const orders = await Order.find({'owner': userId});
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
    const orderId = req.params.orderId;

    if (!req.user) {
        return res.status(401).json({
            success: false,
            message: 'User not authenticated.'
        });
    }
    
    try {
        const order = await Order.findById(orderId);
        
        if (!order) {
          return res.status(404).json({
            success: false,
            message: 'Order not found'
          });
        }
    
        return res.json({
          success: true,
          order,
        });
      } catch (error) {
        return res.status(500).json({
          success: false,
          message: error.message
        });
      }
  });
  
// get('/get-order', async (req, res) => {
//     const user_id = req.user.user_id;
//     try {
//         const getOrder = await Order.findOne({
//             owner: user_id,
//             status:{
//                 status: "Unpaid"
//             }
//         });
//         return res.json({
//             success: true,
//             getOrder
//         });
//     } catch (error) {
//         return res.json({
//             success: false,
//             message: error
//         });
//     }
// })

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