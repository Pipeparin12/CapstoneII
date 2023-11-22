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

export async function updateOrderFunc(updateDetail: UpdateOrderStatusRequestProp) {

    console.log("click");
    
    const updateOrder = await Order.findOneAndUpdate({
        _id: updateDetail.owner
        }, {
            status: updateDetail.status
        }
    )
    return updateOrder;
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

export type UpdateOrderStatusRequestProp = {
    owner: string,
    status: {
        status: string,
        description: string
    }
}

type GetOrderId = {
    
}

orderRoute.get('/all-unpaid', async (req, res) => {
    try {
        const userId = await req.user.user_id;
        const orders = await Order.find({'owner': userId, 'status.status': 'Unpaid'});
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

orderRoute.get('/all-process', async (req, res) => {
    try {
        const userId = await req.user.user_id;
        const orders = await Order.find({'owner': userId, 'status.status': { $in: ['Waiting for confirm order.', 'Packing', 'On the way'] }});
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

orderRoute.get('/waiting', async (req, res) => {
    try {
        const orders = await Order.find({ 'status.status': 'Waiting for confirm order.' });
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

orderRoute.get('/packing', async (req, res) => {
    try {
        const orders = await Order.find({ 'status.status': 'Packing' });
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

orderRoute.get('/on-the-way', async (req, res) => {
    try {
        const orders = await Order.find({ 'status.status': 'On the way' });
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

orderRoute.get('/complete', async (req, res) => {
    try {
        const orders = await Order.find({'status.status': 'Complete'});
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

orderRoute.get('/all-shipped', async (req, res) => {
    try {
        const userId = await req.user.user_id;
        const orders = await Order.find({'owner': userId, 'status.status': 'Shipped'});
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

orderRoute.patch('/update-status/:orderId', async (req, res) => {
    const orderId = req.params.orderId;

    try {
        const updateOrder = await Order.findOneAndUpdate(
            { _id: orderId },
            {
                $set: {
                    'status.status': 'Packing',
                    'status.description': 'Waiting for tracking number'
                }
            },
            { new: true }
        );

        if (!updateOrder) {
            return res.status(404).json({
                success: false,
                message: 'Order not found'
            });
        }

        return res.json({
            success: true,
            updateOrder
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

orderRoute.patch('/update-tracking/:orderId', async (req, res) => {
    const orderId = req.params.orderId;
    const updateDetail = req.body;

    try {
        const updateOrder = await Order.findOneAndUpdate(
            { _id: orderId },
            {
                $set: {
                    'status.status': 'On the way',
                    'status.description': updateDetail.description
                }
            },
            { new: true }
        );

        if (!updateOrder) {
            return res.status(404).json({
                success: false,
                message: 'Order not found'
            });
        }

        return res.json({
            success: true,
            updateOrder
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

orderRoute.patch('/update-shipment/:orderId', async (req, res) => {
    const orderId = req.params.orderId;

    try {
        const updateOrder = await Order.findOneAndUpdate(
            { _id: orderId },
            {
                $set: {
                    'status.status': 'Shipped',
                }
            },
            { new: true }
        );

        if (!updateOrder) {
            return res.status(404).json({
                success: false,
                message: 'Order not found'
            });
        }

        return res.json({
            success: true,
            updateOrder
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

orderRoute.patch('/confirm-shipped/:orderId', async (req, res) => {
    const orderId = req.params.orderId;

    try {
        const updateOrder = await Order.findOneAndUpdate(
            { _id: orderId },
            {
                $set: {
                    'status.status': 'Completed',
                }
            },
            { new: true }
        );

        if (!updateOrder) {
            return res.status(404).json({
                success: false,
                message: 'Order not found'
            });
        }

        return res.json({
            success: true,
            updateOrder
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

export default orderRoute;