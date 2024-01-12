<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group whichn
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('index');
});
//用户登录
Route::post('/api/userLogin','Api\UserController@user_login');
Route::group(['prefix' => 'api','middleware'=>['checkUserLogin','web']],function(){
    //获取商品图片
    Route::get('/getImage','Api\InventoryController@get_image');
    //用户登出
    Route::get('/userLogout','Api\UserController@user_logout');
    //获取供货商列表
    Route::get('/getContactList','Api\ContactController@get_list');
    //获取职员列表
    Route::get('/getEmployeeList','Common\EmployeeController@get_list');
    //获取商品列表
    Route::get('/getGoodsList','Api\InventoryController@get_list');
    //添加商品
    Route::post('/addGoods','Api\InventoryController@add_goods');
    //修改商品
    Route::post('/updateGoods','Api\InventoryController@update_goods');
    //仓库资源路由
    Route::resource('storage','Api\StorageController');
    //仓库资源路由
    Route::get('/summary','Api\InventoryController@get_summary_data');
    //获取订单编号
    Route::get('/getListCode/{type}',function($type){
        echo json_encode(['status'=>'success','success'=>true,'msg'=>'编号获取成功！','data'=>['code'=>$type.date("YmdHis").rand(0,9)]]);
        return;
    });
    //分类相关api
    Route::group(['prefix'=>'assist'],function(){
        //获取分类列表
        Route::get('/list','Api\AssistController@get_list');
    });
    //客户相关API
    Route::group(['prefix'=>'contact'],function(){
        //客户删除
        Route::post('del','Api\ContactController@delete');
        //客户添加
        Route::post('add','Api\ContactController@add');
        //客户修改
        Route::post('update','Api\ContactController@update');
    });
    //采购相关API
    Route::group(['prefix'=>'invPu'],function(){
        Route::post('addNew','Scm\InvPuController@add');
        //修改销售单
        Route::post('update','Scm\InvPuController@update');
        //审核采购单
        Route::post('checkInvPu','Scm\InvPuController@batchCheckInvPu');
        //反审核采购单
        Route::post('revsCheckInvPu','Scm\InvPuController@rsBatchCheckInvPu');
        //获取销售单列表
        Route::get('getBuyList','Scm\InvPuController@list');
        //通过ID获取销售单详情
        Route::get('getInfo','Scm\InvPuController@get_info');
    });
    //销售相关API
    Route::group(['prefix'=>'invSa'],function(){
        //新增销售单
        Route::post('addNew','Scm\InvSaController@add');
        //修改销售单
        Route::post('update','Scm\InvSaController@update');
        //删除销售单
        Route::post('delete','Scm\InvSaController@delete');
        //审核销售单
        Route::post('checkInvSa','Scm\InvSaController@checkInvSa');
        //反审核销售单
        Route::post('revsCheckInvSa','Scm\InvSaController@revsCheckInvSa');
        //获取销售单列表
        Route::get('getSaleList','Scm\InvSaController@list');
        //通过ID获取销售单详情
        Route::get('getInfo','Scm\InvSaController@get_info');
    });

    //库存相关APi
    Route::group(['prefix'=>'invOi'],function(){
        //获取库存信息
        Route::get('getData','Scm\InvOiController@get_ware_data');
        //获取其他入库列表
        Route::get('list','Scm\InvOiController@list');
        //获取其他入库单详情
        Route::get('info','Scm\InvOiController@info');
        //新增其他入库单
        Route::post('addNew','Scm\InvOiController@add');
        //修改其他入库单
        Route::post('edit','Scm\InvOiController@edit');
        //获取其他出库列表
        Route::get('outList','Scm\InvOiController@outList');
        //获取其他出库详情
        Route::get('outInfo','Scm\InvOiController@outInfo');
        //编辑其他出库
        Route::post('outEdit','Scm\InvOiController@outEdit');
        //新增其他出库单
        Route::post('outAdd','Scm\InvOiController@outAdd');
    });
    //调拨单相关API
    Route::group(['prefix'=>'invTf'],function(){
        //获取调拨单列表
        Route::get('getAllotList','Scm\InvTfController@list');
        //通过ID获取调拨单详情
        Route::get('getInfo','Scm\InvTfController@get_info');
        //修改调拨单
        Route::post('update','Scm\InvTfController@update');
        //新增销售单
        Route::post('addNew','Scm\InvTfController@add');
    });
    //分类资源路由
    Route::resource('category','Api\CategoryController');
    //获取单位列表
    Route::get('/getUnitList','Controller@get_units');
});
