import express from "express";
import Order from '../models/order';
const orderRoute = express.Router();

type addOrderRequestProp = {
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
        bankAccountNumber: string,
        bankName: string
    },
    status: {
        status: string;
        description: string | null;
    }
};

type updateOrderStatusRequestProp = {
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

orderRoute.get('/get/', async (req, res) => {
    const orderId = req.body.orderId;
    try {
        const getOrder = await Order.findById({
            _id: orderId
        }, {

        });
        return res.json({
            success: true,
            getOrder
        });
    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
})

orderRoute.post('/add/', async (req, res) => {
    let orderDetail: addOrderRequestProp = { ...req.body };
    orderDetail.status = {
        status: "unpaid",
        description: ""
    };
    console.log(orderDetail);
    try {
        const newOrder = await Order.create(
            orderDetail
        )
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
    const updateDetail: updateOrderStatusRequestProp = req.body;
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
