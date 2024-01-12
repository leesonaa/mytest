<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Common\Cn2pinyin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InventoryController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->systems   = $this->get_option('system');
    }

    /**
     * 获取图片
     * @param Request $request
     * @return void
     */
    public function get_image(Request $request)
    {
        $id = $request->get('id');
        if(!empty($id)){
            $data = DB::table('goods_img')->where(['invId'=>$id,'isDelete'=>0])->get();
            if (count($data)>0) {
                $data = $data[0];
                $rootPath = $_SERVER['DOCUMENT_ROOT'];
                $url     = $rootPath.'/../../pc/data/upfile/goods/'.$data->name;
                $info    = getimagesize($url);
                $imgdata = fread(fopen($url,'rb'),filesize($url));
                header('content-type:'.$info['mime'].'');
                echo $imgdata;
            }
        }
    }

    /**
     * 获取商品列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_list(Request $request){
        $data = $request->all();
        $where = '';
        if(isset($data['keyword']) && $data['keyword']) {
            $data['keyword'] = addslashes($data['keyword']);
            $access = ['a.number', 'a.name', 'a.spec','a.barCode'];
            $where .= ' AND (';
            foreach ($access as $v) {
                $where .=   $v . ' like ' . ' "%'.$data['keyword'].'%"  OR ';
            }
            $where = rtrim($where,'  OR ');
            $where .= ' )';
        }
        $pageSize = $data['pageSize'] ?? 20;
        $page = $data['page'] ?? 1;
        $offset = ($page - 1) * $pageSize;
        $selectField = 'count(a.id) as num';
        $sql = 'select [selectField] from `ci_goods` as a
                left join
					(select
						invId,
						sum(qty) as totalqty,
						sum(case when billType="INI" then qty else 0 end) as iniqty,
						round(sum(case when transType=150501 or transType=150502 or transType=150807 or transType=150706 or billType="INI" or transType=103091 then amount else 0 end)/sum(case when transType=150501 or transType=150502 or transType=150706 or billType="INI" or transType=103091 then qty else 0 end),2) as iniunitCost,
						sum(case when billType="INI" then amount else 0 end) as iniamount
					from `ci_invoice_info`
					where isDelete=0 group by invId) as b
				on a.id=b.invId  where a.isDelete = 0 '.$where.' ORDER BY a.id DESC';
//        die(str_replace('[selectField]',$selectField,$sql));
        $total = DB::select(str_replace('[selectField]',$selectField,$sql));
        $total = json_decode(json_encode($total),true)[0]['num'];
        $storage = DB::table('storage')->where('isDelete',0)->get()->toArray();
        $selectField = 'a.*,b.iniqty,b.iniunitCost,b.iniamount,b.totalqty';
        $offsetSql = '  LIMIT '.$offset.','.$pageSize;
        $list = array_map('get_object_vars',DB::select(str_replace('[selectField]',$selectField,$sql).$offsetSql));
        $profit = $this->get_profit('and billDate<="'.date('Y-m-d').'"');
        foreach ($list as $arr=>$row) {
//            $coast_list = [];
////            dd($row);
//            foreach($storage as $k=>$v){
//                $price = $profit['inprice'][$row['invId']][$v['id']] ?? 0;   //单位成本
//
//            }
//            dd($price);
            $imgList = DB::table('goods_img')->where(['invId'=>$row['id'],'isDelete'=>0])->get();
            $list[$arr]['amount']        = $row['iniamount'] ? (float)$row['iniamount'] : (float) 0;
            $list[$arr]['barCode']       = $row['barCode'];
            $list[$arr]['categoryName']  = $row['categoryName'];
            $list[$arr]['currentQty']    = $row['totalqty'];                            //当前库存
            $list[$arr]['delete']        = intval($row['disable'])==1 ? true : false;   //是否禁用
            $list[$arr]['discountRate']  = 0;
            $list[$arr]['id']            = intval($row['id']);
            $list[$arr]['isSerNum']      = intval($row['isSerNum']);
            $list[$arr]['josl']          = $row['josl'];
            $list[$arr]['name']          = $row['name'];
            $list[$arr]['number']        = $row['number'];
            $list[$arr]['pinYin']        = $row['pinYin'];
            $list[$arr]['locationId']    = intval($row['locationId']);
            $list[$arr]['locationName']  = $row['locationName'];
            $list[$arr]['locationNo']    = '';
            $list[$arr]['purPrice']      = $row['purPrice'];
            $list[$arr]['quantity']      = $row['iniqty'];
            $list[$arr]['salePrice']     = $row['salePrice'];
            $list[$arr]['skuClassId']    = $row['skuClassId'];
            $list[$arr]['spec']          = $row['spec'];
            $list[$arr]['unitCost']      = $row['iniunitCost'];
            $list[$arr]['unitId']        = intval($row['unitId']);
            $list[$arr]['unitName']      = $row['unitName'];
            $list[$arr]['remark']        = $row['remark'];
            // 客户等级价格
            $list[$arr]['wholesalePrice']     = $row['wholesalePrice'];
            $list[$arr]['vipPrice']      = $row['vipPrice'];
            $list[$arr]['discountRate1']  = $row['discountRate1'];
            $list[$arr]['discountRate2']  = $row['discountRate2'];
            $list[$arr]['udf04']  = $row['udf04'];
            $list[$arr]['udf05']  = $row['udf05'];
            $list[$arr]['udf03']  = $row['udf03'];
            $list[$arr]['img'] = $imgList;
        }
        $totalPage = ceil($total/$pageSize);
        $return = [
            'status'=>'success',
            'msg'=>'数据获取成功！',
            'success'=>true,
            'data'=>[
                'current_page'=>(int)$page,
                'data'=>$list,
                'total'=>$total,
                'next_page_url'=>$totalPage > $page ? $page + 1 : null,
            ]
        ];
        $this->show_msg($return);
    }

    /**
     * 修改商品
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function update_goods(Request $request){
        $data = $request->all();
        $this->checkpurview(69);
        if ($data) {
            $info = [];
            $access = array(
                'barCode','baseUnitId','unitName','categoryId','categoryName','propertys',
                'discountRate1','discountRate2','highQty','locationId','pinYin',
                'locationName','lowQty','name','number','purPrice','warehouseWarning',
                'remark','salePrice','spec','vipPrice','wholesalePrice','warehousePropertys','sonGoods','dopey','udf04','udf05','udf03'
            );
            foreach($access as $v){
                if(isset($data[$v])){
                    $info[$v] = $data[$v];
                }else{
                    $info[$v] = null;
                }
            }
            $info = $this->validform($info);
            $info['id'] = $data['id'];
            if(!$info['locationId']) $this->str_alert(-1,'请选择首选仓库！');
//            DB::table('goods')->where(['id'=>$info['id'],'isDelete'=>0,'number'=>$info['number']])->count() > 0 && $this->str_alert(-1,'商品编号重复');
//            DB::enableQueryLog();
//            dd(DB::getQueryLog());
//            $count = DB::table('goods')->where('id','!=',$info['id'])->where(['isDelete'=>0,'number'=>$info['number']])->first();
//            dd(DB::getQueryLog(),$count);
            DB::table('goods')->where('id','!=',$info['id'])->where(['isDelete'=>0,'number'=>$info['number']])->count() > 0 && $this->str_alert(-1,'商品编号重复');
            $info['dopey']=0;
            if(strlen($info['sonGoods'])>0){
                $sonlist = (array)json_decode($info['sonGoods'],true) ;
                if(count($sonlist)>0){
                    $info['dopey']=1;
                    foreach ($sonlist as $sonkey => $sonrow){
                        if(empty($sonrow['gid']))
                            $this->str_alert(-1,'您所选择的商品ID不存在！请重新选择！');
                        else if(DB::table('goods')->where(['isDelete'=>0,'id'=>$sonrow['gid'],'number'=>$sonrow['number']])->count() <= 0)
                            $this->str_alert(-1,'您所选择的子商品编号“'.$sonrow['number'].'”不存在！请重新选择！');
                    }
                }
            }
            DB::beginTransaction();
            try{
                DB::table('goods')->where(['id'=>$info['id']])->update($info);
                if (strlen($info['propertys'])>0) {
                    $list = (array)json_decode($info['propertys'],true);
                    $invoice_info = [];
                    foreach ($list as $arr=>$row) {
                        $invoice_info[$arr]['invId']         = $info['id'];
                        $invoice_info[$arr]['locationId']    = isset($row['locationId']) ? $row['locationId'] : 0;
                        $invoice_info[$arr]['qty']           = isset($row['quantity']) ? $row['quantity']:0;
                        $invoice_info[$arr]['price']         = isset($row['unitCost']) ? $row['unitCost']:0;
                        $invoice_info[$arr]['amount']        = isset($row['amount']) ? $row['amount']:0;
                        $invoice_info[$arr]['skuId']         = isset($row['skuId']) ? $row['skuId']:0;
                        $invoice_info[$arr]['billDate']      = date('Y-m-d');
                        $invoice_info[$arr]['billNo']        = '期初数量';
                        $invoice_info[$arr]['billType']      = 'INI';
                        $invoice_info[$arr]['transTypeName'] = '期初数量';
                    }
                    if (isset($invoice_info)) {
                        DB::table('invoice_info')->where(['invId'=>$info['id'],'billType'=>'INI'])->delete();
                        DB::table('invoice_info')->insert($invoice_info);
                    }
                }
                if (strlen($info['warehousePropertys'])>0) {
                    $list = (array)json_decode($info['warehousePropertys'],true);
                    $s = [];
                    foreach ($list as $arr=>$row) {
                        $s[$arr]['invId']         = $data['id'];
                        $s[$arr]['locationId']    = isset($row['locationId']) ? $row['locationId'] : 0;
                        $s[$arr]['highQty']       = isset($row['highQty']) ? $row['highQty']:0;
                        $s[$arr]['lowQty']        = isset($row['lowQty']) ? $row['lowQty']:0;
                    }
                    if (isset($s)) {
                        DB::table('warehouse')->where(['invId'=>$data['id']])->delete();
                        DB::table('warehouse')->insert($s);
                    }
                }
                $this->logs('修改商品:ID='.$info['id'].'名称:'.$info['name'],$request);
                DB::commit();
                $return = ['status'=>'success','msg'=>'保存成功！','data'=>$this->get_goods_info($info['id'])];
            }catch (\Exception $e) {
                //接收异常处理并回滚
                DB::rollBack();
                $return = ['status'=>'error','msg'=>'SQL错误！','success'=>false];
            }
            $this->show_msg($return);
        }
        $this->str_alert(-1,'修改失败');
    }

    /**
     * 通过ID 获取商品信息
     * @param $id
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function get_goods_info($id) {
        $data = json_decode(json_encode(DB::table('goods')->where(['id'=>$id,'isDelete'=>0])->first()),true);
        if (count($data)>0) {
            $data['id']            = $id;
            $data['count']         = 0;
            $data['name']          = $data['name'];
            $data['spec']          = $data['spec'];
            $data['number']        = $data['number'];
            $data['salePrice']     = (float)$data['salePrice'];
            $data['purPrice']      = (float)$data['purPrice'];
            $data['wholesalePrice']= (float)$data['wholesalePrice'];
            $data['vipPrice']      = (float)$data['vipPrice'];
            $data['discountRate1'] = (float)$data['discountRate1'];
            $data['discountRate2'] = (float)$data['discountRate2'];
            $data['unitTypeId']    = intval($data['unitTypeId']);
            $data['baseUnitId']    = intval($data['baseUnitId']);
            $data['locationId']    = intval($data['locationId']);
            $data['assistIds']     = '';
            $data['assistName']    = '';
            $data['assistUnit']    = '';
            $data['remark']        = $data['remark'];
            $data['categoryId']    = intval($data['categoryId']);
            $data['unitId']        = intval($data['unitId']);
            $data['length']        = '';
            $data['weight']        = '';
            $data['jianxing']      = '';
            $data['barCode']       = $data['barCode'];
            $data['josl']          = '';
            $data['warehouseWarning']          = intval($data['warehouseWarning']);
            $data['warehouseWarningSku']       = 0;
            $data['skuClassId']          = 0;
            $data['isSerNum']            = 0;
            $data['pinYin']              = $data['pinYin'];
            $data['delete']              = false;
            $data['isWarranty']    = 0;
            $data['safeDays']      = 0;
            $data['advanceDay']    = 0;
            $data['property']      = $data['property'] ? $data['property'] : NULL;
            $propertys = $this->get_invoice_info('a.isDelete=0 and a.invId='.$id.' and a.billType="INI"');
            foreach ($propertys as $arr=>$row) {
                $v[$arr]['id']            = intval($row['id']);
                $v[$arr]['locationId']    = intval($row['locationId']);
                $v[$arr]['inventoryId']   = intval($row['invId']);
                $v[$arr]['locationName']  = $row['locationName'];
                $v[$arr]['quantity']      = (float)$row['qty'];
                $v[$arr]['unitCost']      = (float)$row['price'];
                $v[$arr]['amount']        = (float)$row['amount'];
                $v[$arr]['skuId']         = intval($row['skuId']);
                $v[$arr]['skuName']       = '';
                $v[$arr]['date']          = $row['billDate'];
                $v[$arr]['tempId']        = 0;
                $v[$arr]['batch']         = '';
                $v[$arr]['invSerNumList'] = '';
            }
            $data['propertys']            = isset($v) ? $v : array();
            if ($data['warehousePropertys']) {
                $warehouse = (array)json_decode($data['warehousePropertys'],true);
                foreach ($warehouse as $arr=>$row) {
                    $s[$arr]['locationId']    = intval($row['locationId']);
                    $s[$arr]['locationName']  = $row['locationName'];
                    $s[$arr]['highQty']       = (float)$row['highQty'];
                    $s[$arr]['lowQty']        = (float)$row['lowQty'];
                }
            }
            $data['warehousePropertys']   = isset($s) ? $s : array();
            if (strlen($data['sonGoods'])>0) {
                $list = (array)json_decode($data['sonGoods'],true);
                foreach ($list as $arr=>$row) {
                    $v[$arr]['number']          = $row['number'];
                    $v[$arr]['name']            = $row['name'];
                    $v[$arr]['spec']            = $row['spec'];
                    $v[$arr]['unitName']        = $row['unitName'];
                    $v[$arr]['qty']             = intval($row['qty']);
                    $v[$arr]['salePrice']       = intval($row['salePrice']);
                    $v[$arr]['gid']             = intval($row['gid']);//add by michen 20170719
                }
            }
            $data['sonGoods']  = isset($v) ? $v : array();

        }
        return $data;
    }

    /**
     * 获取汇总统计信息
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_summary_data()
    {
        $profit = $this->get_profit('and billDate<="'.date('Y-m-d').'"');

        $inventory1  = $inventory2 = 0;
        $list   = $this->get_invBalance('a.isDelete=0 and a.billDate<="'.date('Y-m-d').'" '.$this->get_location_purview().' group by a.invId,a.locationId');
        foreach ($list as $arr=>$row) {
            $price = isset($profit['inprice'][$row['invId']][$row['locationId']]) ? $profit['inprice'][$row['invId']][$row['locationId']] : 0;
            $inventory1 += $row['qty'];
            $inventory2 += $row['qty'] * $price;
        }
        $inventory1 = round($inventory1,$this->systems['qtyPlaces']);
        $inventory2 = round($inventory2,2);

        $fund1 = $fund2 = 0;
        $list = $this->get_account($this->get_admin_purview(1),'a.isDelete=0');
        foreach ($list as $arr=>$row) {
            if ($row['type']==1) {
                $fund1 += $row['amount'];
            } else {
                $fund2 += $row['amount'];
            }
        }
        $fund1 = round($fund1,2);
        $fund2 = round($fund2,2);

        $contact1 = $contact2 = 0;
        $list = $this->get_contact($this->get_contact_purview(),'a.isDelete=0');
        foreach ($list as $arr=>$row) {
            if ($row['type']==-10) {
                $contact1 += $row['amount'];
            } elseif ($row['type']==10) {
                $contact2 += $row['amount'];
            } else {
                $contact1 = 0;
                $contact2 = 0;
            }
        }
        $contact1 = round($contact1,2);
        $contact2 = round($contact2,2);

        $list = $this->get_invoice_infosum('a.isDelete=0 and a.billType="PUR" and billDate>="'.date('Y-m-1').'" and billDate<="'.date('Y-m-d').'" '.$this->get_location_purview().' group by a.invId,a.locationId');
        $purchase1 = 0;
        foreach ($list as $arr=>$row) {
            $purchase1 += $row['sumamount'];
        }
        $purchase2 = count($list);
        $purchase1 = round($purchase1,2);
        $purchase2 = round($purchase2,$this->systems['qtyPlaces']);

        $sales1 = $sales2 = 0;
        $list   = $this->get_invoice_infosum('a.isDelete=0 and billType="SALE" and billDate>="'.date('Y-m-1').'" and billDate<="'.date('Y-m-d').'" '.$this->get_location_purview().' group by a.invId,a.locationId');
        foreach ($list as $arr=>$row) {
            $qty = $row['sumqty']>0 ? -abs($row['sumqty']):abs($row['sumqty']);
            $amount = $row['sumamount'];
            $price = isset($profit['inprice'][$row['invId']][$row['locationId']]) ? $profit['inprice'][$row['invId']][$row['locationId']] : 0;
            $cost = $price * $qty;
            $saleProfit = $amount - $cost;
            $sales1 += $amount;
            $sales2 += $saleProfit;
        }
        $sales1 = round($sales1,2);
        $sales2 = round($sales2,2);
        $data['status'] = 200;
        $data['msg']    = 'success';
        $data['data']['items'] =  array(
            array('mod'=>'inventory','total1'=>$inventory1,'total2'=>$inventory2),
            array('mod'=>'fund','total1'=>$fund1,'total2'=>$fund2),
            array('mod'=>'contact','total1'=>$contact1,'total2'=>$contact2),
            array('mod'=>'sales','total1'=>$sales1,'total2'=>$sales2),
            array('mod'=>'purchase','total1'=>$purchase1,'total2'=>$purchase2)
        );
        $data['totalsize'] = 5;
        die(json_encode($data));
    }

    /**
     * 添加商品
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function add_goods(Request $request){
        $data = $request->all();
        $this->checkpurview(69);
        $access = array(
            'barCode','baseUnitId','unitName','categoryId','categoryName','propertys',
            'discountRate1','discountRate2','highQty','locationId','pinYin',
            'locationName','lowQty','name','number','purPrice','warehouseWarning',
            'remark','salePrice','spec','vipPrice','wholesalePrice','warehousePropertys','sonGoods','dopey','udf04','udf05','udf03'
        );
        $info = [];
        foreach($access as $v){
            if(isset($data[$v])){
                $info[$v] = $data[$v];
            }else{
                $info[$v] = null;
            }
        }
        $info = $this->validform($info);
//        dd(DB::table('goods')->where(['isDelete'=>0,'number'=>$data['number']])->count());
        DB::table('goods')->where(['isDelete'=>0,'number'=>$data['number']])->count() > 0 && $this->str_alert(-1,'商品编号重复');
        isset($info['barCode']) && $info['barCode'] && DB::table('goods')->where(['isDelete'=>0,'barCode'=>$info['barCode']])->count() > 0 && $this->str_alert(-1,'商品条码已经存在！');
        isset($data['spec']) && $data['spec'] && DB::table('assistsku')->where(['isDelete'=>0,'skuName'=>$data['spec']])->count() > 0 && $this->str_alert(-1,'商品规格已经存在！');
        $info['dopey']=0;
        if(strlen($info['sonGoods'])>0){
            $sonlist = (array)json_decode($data['sonGoods'],true) ;
            if(count($sonlist)>0){
                $info['dopey']=1;
                foreach ($sonlist as $sonkey => $sonrow){
                    if(empty($sonrow['gid']))
                        $this->str_alert(-1,'您所选择的商品ID不存在！请重新选择！');
                    else if(DB::table('goods')->where(['isDelete'=>0,'id'=>$sonrow['gid'],'number'=>$sonrow['number']])->count() <= 0)
                        $this->str_alert(-1,'您所选择的子商品编号“'.$sonrow['number'].'”不存在！请重新选择！');
                }
            }
        }
        if ($info) {
            DB::beginTransaction();
            try{
                $info['id'] = DB::table('goods')->insertGetId($info);
                if (strlen($info['propertys'])>0) {
                    $list = (array)json_decode($info['propertys'],true);
                    $invoice_info = [];
                    foreach ($list as $arr=>$row) {
                        $invoice_info[$arr]['invId']         = $info['id'];
                        $invoice_info[$arr]['locationId']    = intval($row['locationId']);
                        $invoice_info[$arr]['qty']           = (float)$row['quantity'];
                        $invoice_info[$arr]['price']         = (float)$row['unitCost'];
                        $invoice_info[$arr]['amount']        = (float)$row['amount'];
                        $invoice_info[$arr]['skuId']         = intval($row['skuId']);
                        $invoice_info[$arr]['billDate']      = date('Y-m-d');;
                        $invoice_info[$arr]['billNo']        = '期初数量';
                        $invoice_info[$arr]['billType']      = 'INI';
                        $invoice_info[$arr]['transTypeName'] = '期初数量';
                    }
                    if (count($invoice_info) > 0) {
                        DB::table('invoice_info')->insert($invoice_info);
                    }
                }
                if (strlen($info['warehousePropertys'])>0) {
                    $list = (array)json_decode($info['warehousePropertys'],true);
                    foreach ($list as $arr=>$row) {
                        $s[$arr]['invId']         = $data['id'];
                        $s[$arr]['locationId']    = intval($row['locationId']);
                        $s[$arr]['highQty']       = (float)$row['highQty'];
                        $s[$arr]['lowQty']        = (float)$row['lowQty'];
                    }
                    if (isset($s)) {
                        DB::table('warehouse')->insert($s);
                    }
                }
                $this->logs('新增商品:'.$info['name'],$request);
                $return  = ['status'=>'success','msg'=>'保存成功！','success'=>true,'data'=>$info];
                DB::commit();
            }catch (\Exception $e) {
                //接收异常处理并回滚
                DB::rollBack();
                $return  = ['status'=>'error','msg'=>'SQL错误！','success'=>false];
            }
        }
        $this->show_msg($return);
    }

    /**
     * 公共验证
     * @param $data
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function validform($data) {
        $pinyin = New Cn2pinyin();
        isset($data['name']) && strlen($data['name']) < 1 && $this->str_alert(-1,'商品名称不能为空');
        isset($data['number']) && strlen($data['number']) < 1 && $this->str_alert(-1,'商品编号不能为空');
        $data['categoryId'] = intval($data['categoryId']);
        $data['baseUnitId'] = intval($data['baseUnitId']);
        $data['categoryId'] < 1 && $this->str_alert(-1,'商品类别不能为空');
        $data['baseUnitId'] < 1 && $this->str_alert(-1,'计量单位不能为空');
        $data['id']        = isset($data['id']) ? intval($data['id']):0;
        $data['lowQty']    = isset($data['lowQty']) ? (float)$data['lowQty'] :0;
        $data['highQty']   = isset($data['highQty']) ? (float)$data['highQty']:0;
        $data['purPrice']  = isset($data['purPrice']) ? (float)$data['purPrice']:0;
        $data['salePrice'] = isset($data['salePrice']) ? (float)$data['salePrice']:0;
        $data['vipPrice']  = isset($data['vipPrice']) ? (float)$data['vipPrice']:0;
        $data['warehouseWarning']  = isset($data['warehouseWarning']) ? intval($data['warehouseWarning']):0;
        $data['discountRate1']  = (float)$data['discountRate1'];
        $data['discountRate2']  = (float)$data['discountRate2'];
        $data['wholesalePrice'] = isset($data['wholesalePrice']) ? (float)$data['wholesalePrice']:0;
        $data['unitName']     = DB::table('unit')->where(['id'=>$data['baseUnitId']])->value('name');
        $data['categoryName'] = DB::table('category')->where(['id'=>$data['categoryId']])->value('name');
        $data['pinYin'] = $pinyin->encode($data['name']);
        !$data['categoryName'] && $this->str_alert(-1,'商品类别不存在');
        if (strlen($data['propertys'])>0) {
            $list         = (array)json_decode($data['propertys'],true);
            $storage      = DB::table('storage')->where(['disable'=>0])->get()->map(function ($value) {
                return (array)$value;
            })->toArray();
            $locationId   =  array_column($storage,'id');
            $locationName =  array_column($storage,'name','id');
            foreach ($list as $arr=>$row) {
                !in_array($row['locationId'],$locationId) && $this->str_alert(-1,$locationName[$row['locationId']].'仓库不存在或不可用！');
            }
        }
        $data['warehousePropertys'] = isset($data['warehousePropertys']) ? $data['warehousePropertys'] :'[]';
        $data['warehousePropertys'] = count(json_decode($data['warehousePropertys'],true))>0 ? $data['warehousePropertys'] :'';
        return $data;
    }
}
