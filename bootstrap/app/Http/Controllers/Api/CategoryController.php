<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function index(Request $request)
    {
        $data = $request->all();
        $typeNumber   = $this->str_enhtml($data['typeNumber']);
        $skey   = isset($data['skey']) && $data['skey'] ? $this->str_enhtml($data['skey']) : '';
        $where  = '(isDelete=0) and typeNumber= ? ';
        $where .= $skey ? ' and name like  ? ' : '';
//        $list = $this->mysql_model->get_results('category',$where,'path');
        $list = Category::whereRaw($where,[$typeNumber,"%'.$skey.'%"])->orderBy('path')->select()->get()->toArray();
        $parentId  = array_column($list, 'parentId');
        foreach ($list as $arr=>$row) {
            $v[$arr]['detail']      = in_array($row['id'],$parentId) ? false : true;
            $v[$arr]['id']          = intval($row['id']);
            $v[$arr]['level']       = $row['level'];
            $v[$arr]['name']        = $row['name'];
            $v[$arr]['parentId']    = intval($row['parentId']);
            $v[$arr]['remark']      = $row['remark'];
            $v[$arr]['sortIndex']   = intval($row['sortIndex']);
            $v[$arr]['status']      = intval($row['isDelete']);
            $v[$arr]['typeNumber']  = $row['typeNumber'];
            $v[$arr]['path']        = $row['path'];
        }
        $json['status'] = 'success';
        $json['msg']    = '数据获取成功！';
        $json['data']['data']      = isset($v) ? $v : [];
        $json['data']['totalsize']  = count($list);
        $this->show_msg($json);
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
