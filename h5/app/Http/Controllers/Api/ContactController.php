<?php
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Common\Cn2pinyin;
use App\Http\Controllers\Controller;
use App\Http\Models\Admin;
use App\Http\Models\Contact;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ContactController extends Controller
{
    /**
     * 获取客户、供货商列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_list(Request $request){
        $session = session('loginUser');
        $uid = 0;
        if($session['roleid'] !== 0){
            $uid = $session['uid'];
            $user = Admin::where('uid',$uid)->first();
        }
        $data = $request->all();
        $sql = ' isDelete = ? AND type = ? ';
//        $sql .= $uid > 0 ? ' AND create_user = ?' : '';
        $field = [0,10];
//        if($uid > 0){
//            $field[] = $uid;
//        }
        $data['type'] = isset($data['type']) && $data['type'] == 10 ? 10 : -10;
        $field[1] = $data['type'];
        if($session['roleid'] !== 0) {
            if ($data['type'] == 10) {
                $sql .= ' AND id in(' . $user['righttype4'] . ')';
            } else {
                $sql .= ' AND id in(' . $user['righttype2'] . ')';
            }
        }
        if(isset($data['keyword']) && $data['keyword']) {
            $access = ['number', 'name', 'linkMans'];
            $sql .= ' AND (';
            foreach ($access as $v) {
                $sql .=   $v . ' like ' . ' ?  OR ';
                $field[] = '%'.$data['keyword'].'%';
            }
            $sql = rtrim($sql,'  OR ');
            $sql .= ' )';
        }
        $pageSize = $data['pageSize'] ?? 20;
        //开启数据库日志查询
//        DB::enableQueryLog();
        $list = Contact::select(['*','name as title'])->whereRaw($sql,$field)->orderBy('id','desc')->paginate($pageSize)->toArray();
        foreach ($list['data'] as &$row) {
            $row['id']           = intval($row['id']);
            $row['cCategory']    = intval($row['cCategory']);
            $row['customerType'] = $row['cCategoryName'];
            $row['delete']       = intval($row['disable'])==1 ? true : false;
            $row['cLevel']       = intval($row['cLevel']);
            $row['amount']       = (float)$row['amount'];
            $row['periodMoney']  = (float)$row['periodMoney'];
            $row['difMoney']     = (float)$row['difMoney'];
            $row['taxRate']      = (float)$row['taxRate'];
            $row['links']        = '';
            $row['linkMen']      = $row['linkMans'];
            if (strlen($row['linkMans'])>0) {
                $linkMans = (array)json_decode($row['linkMans'],true);
                foreach ($linkMans as $row1) {
                    if (isset($row1['linkFirst']) && $row1['linkFirst'] ==1) {
                        $row['contacter']            = isset($row1['linkName']) && $row1['linkName'] ? $row1['linkName'] : '' ;
                        $row['mobile']               = isset($row1['linkMobile']) && $row1['linkMobile'] ? $row1['linkMobile'] : '';
                        $row['place']                = isset($row1['linkPlace']) && $row1['linkMobile'] ? $row1['linkPlace'] : '';
                        $row['telephone']            = isset($row1['linkPhone']) && $row1['linkPhone'] ? $row1['linkPhone'] : '';
                        $row['linkIm']               = isset($row1['linkIm']) && $row1['linkIm'] ? $row1['linkIm'] : '';
                        $row['city']                 = isset($row1['city']) && $row1['city'] ? $row1['city'] : '';
                        $row['county']               = isset($row1['county']) && $row1['county'] ? $row1['county'] : '';
                        $row['province']             = isset($row1['province']) && $row1['province'] ?  $row1['province'] : '';
                        $row['deliveryAddress']      = isset($row1['address']) && $row1['address'] ? $row1['address'] : '';
                        $row['firstLink']['first']   = isset($row1['linkFirst']) && $row1['linkFirst'] ? $row1['linkFirst'] : '';
                    }
                }
            }
        }
//        打印最后的sql语句
//        dd(DB::getQueryLog());
        $this->show_msg(['status'=>'success','msg'=>'数据获取成功！','data'=>$list,'success'=>true]);
    }

    /**
     * 删除商户信息
     * @author : zl
     * @email : 932460566@qq.com
     * @param Request $request
     */
    public function delete(Request $request){
        $params = $request->all();
        $id = $params['id'] ?? [];
        if($id){
            $id = explode(',',$id);
        }
        $type = !empty($params['type']) ? (intval($params['type']) == 10 ? 10 : -10) : 10;
        switch ($type) {
            case 10:
                $this->checkpurview(61);
                $success = '删除客户:';
                break;
            case -10:
                $this->checkpurview(66);
                $success = '删除供应商:';
                break;
            default:
                $this->str_alert(-1,'参数错误');
        }
        $data = DB::table('contact')->whereIn('id',$id)->get();
        if (count($data) > 0) {
            $info['isDelete'] = 1;
            $count = DB::table('invoice')->where(['isDelete'=>0])->whereIn('id',$id)->count();
            if($count > 0){
                $this->str_alert(-1,'不能删除有业务往来的客户或供应商！');
            }
            $res = DB::table('contact')->whereIn('id',$id)->update($info);
            if ($res) {
                $name = array_column($data->toArray(),'name');
                $this->logs($success.'ID='.implode(',',$id).' 名称:'.implode(',',$name),$request);
                $this->str_alert(200,"success",['id'=>$id]);
            }
        }
        $this->str_alert(-1,'客户或供应商不存在');
    }

    /**
     * 添加客户信息
     * @author : zl
     * @email : 932460566@qq.com
     * @param Request $request
     */
    public function add(Request $request)
    {
        $session = session('loginUser');
        $data = $this->validform($request->all());
        switch ($data['type']) {
            case 10:
                $this->checkpurview(59);
                $success = '新增客户:';
                break;
            case -10:
                $this->checkpurview(64);
                $success = '新增供应商:';
                break;
            default:
                $this->str_alert(-1,'参数错误');
        }
        $insert = $this->formatData($data,false);
        $insert['create_user'] = $session['uid'];
        $res = DB::table('contact')->insertGetId($insert);
        if ($res) {
            $data['id'] = $res;
            $data['cCategory'] = intval($data['cCategory']);
            $data['linkMans']  = (array)json_decode($data['linkMans'],true);
            $this->logs($success.$data['name'],$request);
            $this->str_alert(200,'success',$data);
        }
        $this->str_alert(-1,'添加失败');
    }

    /**
     * 修改客户信息
     * @author : leo
     * @email : 932460566@qq.com
     * @param Request $request
     */
    public function update(Request $request)
    {
        $data = $this->validform($request->all());
        switch ($data['type']) {
            case 10:
                $this->checkpurview(60);
                $success = '修改客户:';
                break;
            case -10:
                $this->checkpurview(65);
                $success = '修改供应商:';
                break;
            default:
                $this->str_alert(-1,'参数错误');
        }
        $update = $this->formatData($data);
        if(!empty($data['taxRate'])){
            $update['taxRate'] = intval($data['taxRate']);
        }
        $res = DB::table('contact')->where(['id'=>$data['id']])->update($update);
        if ($res) {
            $data['cCategory']    = intval($data['cCategory']);
            $data['customerType'] = $data['cCategoryName'];
            $data['linkMans']     = (array)json_decode($data['linkMans'],true);
            $this->logs($success.$data['name'],$request);
            $this->str_alert(200,'success',$data);
        }
        $this->str_alert(-1,'更新失败');
    }

    /**
     * 格式化提交数据
     * @author : leo
     * @email : 932460566@qq.com
     * @param $data
     * @param bool $isUpdate
     * @return array
     */
    private function formatData($data,$isUpdate = true)
    {
        $where = [['isDelete','=',0],['type','=',$data['type']],['number','=',$data['number']]];
        if($isUpdate){
            $where[] = ['id','<>',$data['id']];
        }
        DB::table('contact')->where($where)->count() > 0 && $this->str_alert(-1,'编号重复');
        $info = [
            'name','number','amount','beginDate','cCategory',
            'cCategoryName','cLevel','cLevelName','linkMans'
            ,'periodMoney','remark','type','difMoney'];
        $update = [];
        foreach($info as $v){
            if(isset($data[$v])){
                $update[$v] = $data[$v];
            }else{
                $update[$v] = NULL;
            }
        }
        return $update;
    }

    /**
     * 公共验证方法
     * @author : zl
     * @email : 932460566@qq.com
     * @param $data
     * @return mixed
     */
    private function validform($data) {

        strlen($data['name']) < 1 && $this->str_alert(-1,'名称不能为空');
        strlen($data['number']) < 1 && $this->str_alert(-1,'编号不能为空');
        $data['cCategory']     = intval($data['cCategory']);
        $data['cLevel']        = (float)($data['cLevel'] ?? 0);
        $data['taxRate']       = isset($data['taxRate']) ? (float)$data['taxRate'] :0;
        $data['periodMoney']   = (float)$data['periodMoney'];
        $data['amount']        = (float)$data['amount'];
        $data['linkMans']      = $data['linkMans'] ?? "[]";
        $data['beginDate']     = $data['beginDate'] ?? date('Y-m-d');
        $data['type']          = !empty($data['type']) && $data['type'] == 10 ? 10 : -10;
        $data['pinYin']        = (new Cn2pinyin)->str2pinyin($data['name']);
        $data['contact']       = $data['number'].' '.$data['name'];
        $data['difMoney']      = $data['amount'] - $data['periodMoney'];
        $data['cCategoryName'] = DB::table('category')->where(['id'=>$data['cCategory']])->first(['name'])->name;
        $data['cCategory'] < 1 && $this->str_alert(-1,'类别名称不能为空');
        return $data;
    }
}
