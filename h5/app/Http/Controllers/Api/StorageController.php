<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Models\Admin;
use App\Http\Models\Storage;
use Illuminate\Http\Request;

class StorageController extends Controller
{
    /**
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function index(Request $request)
    {
        //
        $sql = ' isDelete = ?';
        $field = [0];
        $session = session('loginUser');
        if($session['roleid'] !== 0){
            $uid = $session['uid'];
            $user = Admin::where('uid',$uid)->first();
            $sql .= ' AND id in(' . $user['righttype1'] . ')';
        }
        $list = Storage::whereRaw($sql,$field)->get()->toArray();
        $this->show_msg(['status'=>'success','msg'=>'数据获取成功！','data'=>$list,'success'=>true]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
