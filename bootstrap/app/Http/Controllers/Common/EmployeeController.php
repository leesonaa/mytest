<?php

namespace App\Http\Controllers\Common;

use App\Http\Controllers\Controller;
use App\Http\Models\Employee;
use Illuminate\Http\Request;

class EmployeeController extends Controller
{
    //获取职员列表
    public function get_list(Request $request){
        $data = $request->all();
        $data['isDelete'] = isset($data['isDelete']) ? (int)$data['isDelete'] : 0;
        $list = Employee::where(['isDelete'=>$data['isDelete']])->orderBy('id','desc')->get()->toArray();
        $v = [];
        foreach ($list as $arr=>$row) {
            $v[$arr]['birthday']    =$row['birthday'];
            $v[$arr]['allowNeg']    = false;
            $v[$arr]['commissionrate'] = $row['commissionrate'];
            $v[$arr]['creatorId']    = $row['creatorId'];
            $v[$arr]['deptId']       = $row['deptId'];
            $v[$arr]['description']  = $row['description'];
            $v[$arr]['email']        = $row['name'];
            $v[$arr]['empId']        = $row['empId'];
            $v[$arr]['empType']      = $row['empType'];
            $v[$arr]['fullId']       = $row['fullId'];
            $v[$arr]['id']           = intval($row['id']);
            $v[$arr]['leftDate']     = NULL;
            $v[$arr]['mobile']       = $row['mobile'];
            $v[$arr]['name']         = $row['name'];
            $v[$arr]['number']       = $row['number'];
            $v[$arr]['parentId']     = $row['parentId'];
            $v[$arr]['sex']          = $row['sex'];
            $v[$arr]['userName']     = $row['userName'];
            $v[$arr]['delete']       = intval($row['disable'])==1 ? true : false;   //是否禁用
        }
        $return = ['status'=>'success','msg'=>'数据获取成功！','data'=>$v,'success'=>true];
        $this->show_msg($return);
    }
}
