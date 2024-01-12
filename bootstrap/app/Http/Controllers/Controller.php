<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;
    protected $jxcsys;
    public function __construct()
    {
//        dd(session('loginUser'));
    }

    /**
     * 格式化参数
     * @param $field
     * @param $data
     * @param $default
     * @return array
     */
    public function formatParams($field,$data,$default=null)
    {
        $info = [];
        foreach($field as $v){
            $info[$v] = $data[$v] ?? $default;
        }
        return $info;
    }

    /**
     * 获取管理员用户
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_admin() {
        $this->jxcsys = session()->get('loginUser');
        return json_decode(json_encode(DB::table('admin')->where(['uid'=>$this->jxcsys['uid'],'status'=>1])->first()),true);
    }


    /**
     * 获取管理员权限
     * @param string $type
     * @return string
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_admin_purview($type='') {
        $data = $this->get_admin();
        $rightids = explode(',',$data['rightids']);
        if ($type==1) {
            $where = in_array(8,$rightids) && $data['roleid']>0 && strlen($data['righttype8'])>0  ? ' and uid in('.$data['righttype8'].')' : '';
        } else {
            $where = in_array(8,$rightids) && $data['roleid']>0 && strlen($data['righttype8'])>0  ? ' and a.uid in('.$data['righttype8'].')' : '';
        }
        return $where;
    }

    /**
     * 检测用户是否有权限
     * @param int $id
     * @return bool
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function checkpurview($id=0) {
        if ($id>0) {
            $data = $this->get_admin();
            if ($data && count($data)>0) {
                if ($data['roleid']==0) return true;
                if (in_array($id,explode(',',$data['lever']))) return true;
            }
            $this->str_alert(-1,'对不起，您没有此页面的管理权');
//            die('对不起，您没有此页面的管理权');//权限不足提示乱码
        }
    }

    /**
     * 获取单位列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_units(Request $request){
        $data = $request->all();
        $unittypeid   = isset($data['unitTypeId']) ? intval($data['unitTypeId']) : 0;
        if ($unittypeid>0) {
            $where['unittypeid'] = $unittypeid;
        }
        $where['isDelete'] = 0;
        $list = array_map('get_object_vars',DB::table('unit')->where($where)->orderBy('id','desc')->get()->toArray());
        foreach ($list as $arr=>$row) {
            $v[$arr]['default']    = $row['default']==1 ? true : false;
            $v[$arr]['guid']       = $row['guid'];
            $v[$arr]['id']         = intval($row['id']);
            $v[$arr]['name']       = $row['name'];
            $v[$arr]['rate']       = intval($row['rate']);
            $v[$arr]['isDelete']   = intval($row['isDelete']);
            $v[$arr]['unitTypeId'] = intval($row['unitTypeId']);
        }
        $json['status'] = 'success';
        $json['msg']    = '数据获取成功';
        $json['data']['data']     = isset($v) ? $v : [];
        $json['data']['total'] = count($list);
        $this->show_msg($json);
    }

    /**
     * 过滤字段特殊内容
     * @param $str
     * @return array|string
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function str_enhtml($str) {
        if (!is_array($str)) return addslashes(htmlspecialchars(trim($str)));
        foreach ($str as $key=>$val) {
            $str[$key] = $this->str_enhtml($val);
        }
        return $str;
    }

    /**
     * 保存日志
     * @param $info
     * @param null $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function logs($info,$request=null) {
        $this->jxcsys       =  $request->session()->get('loginUser');
        $data['userId']     =  $this->jxcsys['uid'];
        $data['name']       =  $this->jxcsys['name'];
        $data['ip']         =  $request->getClientIp();
        $data['log']        =  $info;
        $data['loginName']  =  $this->jxcsys['username'];
        $data['adddate']    =  date('Y-m-d H');
        $data['modifyTime'] =  date('Y-m-d H:i:s');
        DB::table('log')->insert($data);
    }

    /**
     * 获取结算明细     用于其他收支明细表、现金银行报表(明细)
     * @param string $where
     * @param int $type
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_account_info($where='',$type=2) {
        $sql = 'select
		            a.id,a.iid,a.accId,a.buId,a.isDelete,a.billType,a.billNo,a.remark,a.billDate,a.payment,a.wayId,a.settlement,a.transType,a.transTypeName,
					b.name as contactName,b.number as contactNo,
					c.name as categoryName,
					d.name as accountName,d.number as accountNumber
				from ci_account_info as a
				left join
					(select id,name,number from ci_contact where isDelete=0) as b
				on a.buId=b.id
				left join
					(select id,name from ci_category where isDelete=0) as c
				on a.wayId=c.id
				left join
					(select id,name,number from ci_account where isDelete=0) as d
				on a.accId=d.id
				where '.$where;
        return json_decode(json_encode(DB::select($sql)),true);
    }

    /**
     * 获取单据列表明细
     * @param string $where
     * @param int $type
     * @return array
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_invoice_info($where='',$type=2) {
        $sql = 'select
		            a.*,
					b.name as invName, b.number as invNumber, b.spec as invSpec,
					b.unitName as mainUnit,b.pinYin,b.purPrice,b.quantity,b.salePrice,b.unitId,b.barCode,
					c.number as contactNo, c.name as contactName,
					d.name as locationName ,d.locationNo ,
					e.number as salesNo ,e.name as salesName
				from ci_invoice_info as a
					left join
						(select id,name,number,spec,unitName,unitId,pinYin,purPrice,quantity,salePrice,barCode from ci_goods where isDelete=0) as b
					on a.invId=b.id
					left join
						(select id,number, name from ci_contact where isDelete=0) as c
					on a.buId=c.id
					left join
						(select id,name,locationNo from ci_storage where isDelete=0) as d
					on a.locationId=d.id
					left join
						(select id,name,number from ci_staff where isDelete=0) as e
					on a.salesId=e.id
				where '.$where;
        return array_map('get_object_vars',DB::select($sql));
    }

    /**
     * 获取单据列表
     * @param string $where
     * @param int $type
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_invoice($where='',$type=2) {
        switch($type){
            case 1:
            case 2:
                $sql = 'select
		            a.*,
					b.name as contactName,b.number as contactNo,
					c.number as salesNo ,c.name as salesName,
					d.number as accountNumber ,d.name as accountName,
					(a.rpAmount + ifnull(e.nowCheck,0)) as hasCheck
				from ci_invoice as a
					left join
						(select id,number, name from ci_contact where isDelete=0) as b
					on a.buId=b.id
					left join
						(select id,name,number from ci_staff where isDelete=0) as c
					on a.salesId=c.id
					left join
					    (select id,name,number from ci_account where isDelete=0) as d
					on a.accId=d.id
					left join
					    (select billId,sum(nowCheck) as nowCheck from ci_verifica_info where isDelete=0 group by billId) as e
					on a.id=e.billId
				where '.$where;
                return json_decode(json_encode(DB::select($sql)),true);
            break;
            case 3:
                $sql = 'select
		            count(*) as num
				from ci_invoice as a
					left join
						(select id,number, name from ci_contact where isDelete=0) as b
					on a.buId=b.id
					left join
						(select id,name,number from ci_staff where isDelete=0) as c
					on a.salesId=c.id
					left join
					    (select id,name,number from ci_account where isDelete=0) as d
					on a.accId=d.id
					left join
					    (select billId,sum(nowCheck) as nowCheck from ci_verifica_info where isDelete=0 group by billId) as e
					on a.id=e.billId
				where '.$where;
                return DB::select($sql)[0]->num;
            break;
        }
    }

    /**
     * 获取库存 用于判断库存是否满足
     * @return array
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_invoice_info_inventory() {
        $list = DB::select('select invId,locationId,sum(qty) as qty from ci_invoice_info where isDelete=0 group by invId,locationId');
        //对象转为数组
        $list = array_map('get_object_vars',$list);
        foreach($list as $arr=>$row){
            $v[$row['invId']][$row['locationId']] = $row['qty'];
        }
        return isset($v) ? $v :array();
    }

    /**
     * 获取系统配置
     * @param $key
     * @return mixed|string
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_option($key) {
        $option_value = DB::table('options')->where(['option_name'=>$key])->value('option_value');
        return $option_value ? unserialize($option_value) : '';
    }

    public function show_msg($msg){
        exit(json_encode($msg));
    }

    /**
     * json消息
     * @param $code
     * @param $msg
     * @param array $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function str_alert($code,$msg,$data=[]){
        if($code < 0){
            $status = 'error';
            $success = false;
        }else{
            $status = 'success';
            $success = true;
        }
        $msg = [
            'success'=>$success,
            'status' => $status,
            'msg' => $msg,
            'data' => $data,
        ];
        return die(json_encode($msg));
    }

    /**
     * 销售汇总表（按商品） 毛利计算 单价成本
     * @param $where
     * @return array
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_profit($where) {
        $sql = 'select
					invId,locationId,billDate,sum(qty) as qty,
					sum(case when transType=150501 or transType=150502 or transType=150807 or transType=150706 or billType="INI" or transType=103091 then amount else 0 end) as inamount,
					sum(case when transType=150501 or transType=150502 or transType=150706 or billType="INI" or transType=103091 then qty else 0 end) as inqty
				from ci_invoice_info where isDelete=0 '.$where.' group by invId,locationId';
        $list = json_decode(json_encode(DB::select($sql)),true);
        $v = [];
        foreach($list as $arr=>$row){
            $v['qty'][$row['invId']][$row['locationId']]      = $row['qty'];
            $v['inqty'][$row['invId']][$row['locationId']]    = $row['inqty'];
            $v['inamount'][$row['invId']][$row['locationId']] = $row['inamount'];
            $v['inprice'][$row['invId']][$row['locationId']]  = $row['inqty']>0 ? $row['inamount']/$row['inqty'] :0;
        }
        return isset($v) ? $v :[];
    }

    /**
     * 生成where组装字符串
     * @author : zl
     * @email : 932460566@qq.com
     * @param string $type
     * @return string
     */
    public function get_location_purview($type='') {
        $data     = $this->get_admin();
        $rightids = explode(',',$data['rightids']);
        if ($type==1) {
            $where = in_array(1,$rightids) && $data['roleid']>0 && strlen($data['righttype1'])>0  ? ' and id in('.$data['righttype1'].')' : '';
        } else {
            $where = in_array(1,$rightids) && $data['roleid']>0 && strlen($data['righttype1'])>0 ? ' and a.locationId in('.$data['righttype1'].')' : '';
        }
        return $where;
    }

    /**
     * 商品库存余额表(接口)
     * @author : zl
     * @email : 932460566@qq.com
     * @param string $where
     * @param string $select
     * @param int $type
     * @return mixed
     */
    public function get_invBalance($where='',$select='',$type=2) {
        $sql = 'select
		            a.invId,a.locationId,sum(a.qty) as qty,sum(a.amount) as amount,
					'.$select.'
					b.name as invName, b.number as invNumber, b.spec as invSpec, b.unitName as mainUnit, b.categoryId,b.salePrice,
					c.locationNo
				from ci_invoice_info as a
					left join
						(select id,name,number,spec,unitName,categoryId,salePrice from ci_goods where isDelete=0) as b
					on a.invId=b.id
					left join
						(select id,name,locationNo from ci_storage where isDelete=0) as c
					on a.locationId=c.id
				where '.$where;
        return json_decode(json_encode(DB::select($sql)),true);
    }

    /**
     * 获取结算用户     现金银行报表(期初余额)
     * @author : zl
     * @email : 932460566@qq.com
     * @param string $where1
     * @param string $where2
     * @param int $type
     * @return mixed
     */
    public function get_account($where1='',$where2='',$type=2) {
        $sql = 'select
		            a.id,a.date,a.type,a.name as accountName,a.number as accountNumber,
		            b.payment,(a.amount + ifnull(b.payment,0)) as amount
		        from ci_account as a
				left join
				    (select accId,billDate,sum(payment) as payment from ci_account_info where isDelete=0 '.$where1.' GROUP BY accId) as b
			    on a.id=b.accId
				where '.$where2;
        return json_decode(json_encode(DB::select($sql)),true);
    }

    /**
     * 获取供应商客户   用于应付账、收账明细、客户、供应商对账单、来往单位欠款 (期初余额)
     * @author : zl
     * @email : 932460566@qq.com
     * @param string $where1
     * @param string $where2
     * @param int $type
     * @return mixed
     */
    public function get_contact($where1='',$where2='',$type=2) {
        $sql = 'select
					a.id,a.type,a.difMoney,a.name,a.number,(a.difMoney + ifnull(b.arrears,0)) as amount,b.arrears
				from ci_contact as a
				left join
					(select buId,billType,sum(arrears) as arrears from ci_invoice where isDelete=0 '.$where1.' group by buId) as b
			    on a.id=b.buId
				where '.$where2;
        return json_decode(json_encode(DB::select($sql)),true);
    }

    /**
     * 生成查询where串
     * @author : zl
     * @email : 932460566@qq.com
     * @return string
     */
    public function get_contact_purview() {
        $data  = $this->get_admin();
        $rightids = explode(',',$data['rightids']);
        if (in_array(2,$rightids)) {
            $arr[] = $data['righttype2'];
        }
        if (in_array(4,$rightids)) {
            $arr[] = $data['righttype4'];
        }
        $id  = isset($arr) ? join(',',array_filter($arr)) : 0;
        $id  = strlen($id)>0 ? $id : 0;
        return $data['roleid']>0 ? ' and id in('.$id.')' : '';
    }

    /**
     * 获取单据列表统计
     * @author : zl
     * @email : 932460566@qq.com
     * @return string
     */
    public function get_invoice_infosum($where='',$type=2) {
        $sql = 'select
		            a.*,sum(a.qty) as sumqty,sum(a.amount) as sumamount,
					b.name as invName, b.number as invNumber, b.spec as invSpec,
					b.unitName as mainUnit,b.pinYin,b.purPrice,b.quantity,b.salePrice,b.unitId,
					c.number as contactNo, c.name as contactName,
					d.name as locationName ,d.locationNo ,
					e.number as salesNo ,e.name as salesName
				from ci_invoice_info as a
					left join
						(select id,name,number,spec,unitName,unitId,pinYin,purPrice,quantity,salePrice from ci_goods where isDelete=0) as b
					on a.invId=b.id
					left join
						(select id,number, name from ci_contact where isDelete=0) as c
					on a.buId=c.id
					left join
						(select id,name,locationNo from ci_storage where isDelete=0) as d
					on a.locationId=d.id
					left join
						(select id,name,number from ci_staff where isDelete=0) as e
					on a.salesId=e.id
				where '.$where;
        return json_decode(json_encode(DB::select($sql)),true);
    }

    //库存统计
    public function get_inventory($where='',$type=2) {
        $sql = 'select';
        if($type == 3){
            $sql .= ' count(*) as num,sum(a.qty) as qty';
        }else{
            $sql .= ' a.invId,a.locationId,sum(a.qty) as qty,
		            b.name as invName, b.number as invNumber,b.spec as invSpec,b.categoryId ,b.categoryName,b.unitName,b.unitid,b.barCode,
					if(d.lowQty>=0,d.lowQty,b.lowQty) as lowQty,
					if(d.highQty>=0,d.highQty,b.highQty) as highQty,
					(sum(a.qty) - if(d.highQty>=0,d.highQty,b.highQty)) as qty1,
					(sum(a.qty) - if(d.lowQty>=0,d.lowQty,b.lowQty)) as qty2,
					c.name as locationName ';
        }
        $sql .= ' from ci_invoice_info as a
					left join
						(select id,name,number,spec,unitName,unitid,lowQty,highQty,categoryId,categoryName,barCode from ci_goods where isDelete=0) as b
					on a.invId=b.id
					left join
						(select id,name,locationNo from ci_storage where isDelete=0) as c
					on a.locationId=c.id
					left join
						(select id,lowQty,highQty,locationId,invId from ci_warehouse group by invId,locationId) as d
					on a.invId=d.invId and a.locationId=d.locationId
				where '.$where;
        return json_decode(json_encode(DB::select($sql)),true);
    }
}
