<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use App\Http\Models\Admin;
use Illuminate\Http\Request;
use Session;
class
UserController extends Controller
{

    /**
     * 用户登录
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function user_login(Request $request){
        $session = $request->session()->all();
//        dd($session,$request->all());
        $data = $request->all();
        $user = Admin::whereRaw('(username = ? or mobile = ?)',[$data['username'],$data['username']])->first();
        if($user){
            if($user['status'] != 1){
                $return = ['status'=>'error','msg'=>'账号被锁定','success'=>false];
            }else{
                if($user['userpwd'] == md5($data['password'])){
                    $token = md5(time().uniqid());
                    $session = [
                        'uid'=>$user['uid'],
                        'name'=>$user['name'],
                        'roleid'=>$user['roleid'],
                        'username'=>$user['username'],
                        'token'=>$token
                    ];
                    session()->put('loginUser',$session);
                    //session此处必须保存！！！
                    session()->save();
//                    dd(session('loginUser'));
//                    $request->session()->save();
                    $return = ['status'=>'success','msg'=>'登录成功！','success'=>true,'token'=>$token,'role'=>$user['roleid']];
                }else{
                    $return = ['status'=>'error','msg'=>'密码错误！','success'=>false];
                }
            }
        }else{
            $return = ['status'=>'error','msg'=>'用户名/密码错误！','success'=>false];
        }
        $this->show_msg($return);

    }

    /**
     * 用户退出
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function user_logout(Request $request){
        session()->flush();
        //session此处必须保存！！！
        session()->save();
        $this->show_msg(['status'=>'success','msg'=>'成功！','success'=>true]);
    }
}
