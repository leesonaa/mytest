<?php

namespace App\Http\Controllers\Scm;

use App\Http\Controllers\Controller;
use App\Http\Models\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InvTfController extends Controller
{
    /**
     * 获取列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function list(Request $request){
        $this->checkpurview(144);
        $data = $request->all();
        $page = isset($data['page']) && $data['page'] ? $data['page'] : 1;
        $rows = isset($data['pageSize']) && $data['pageSize'] ? $data['pageSize'] : 20;
        $matchCon  = isset($data['matchCon']) ? $this->str_enhtml($data['matchCon']) : '';
        $beginDate = isset($data['start']) ? $this->str_enhtml($data['start']) : '';
        $endDate   = isset($data['end']) ? $this->str_enhtml($data['end']) : '';
        $inLocationId    = isset($data['inLocationId']) ? intval($data['inLocationId']) : 0;
        $outLocationId   = isset($data['outLocationId']) ? intval($data['outLocationId']) : 0;
        $where = 'a.isDelete=0 and a.transType=103091';
        $where .= $matchCon  ? ' and a.postData like "%'.$matchCon.'%"' : '';
        $where .= $beginDate ? ' and a.billDate>="'.$beginDate.'"' : '';
        $where .= $endDate ? ' and a.billDate<="'.$endDate.'"' : '';
        $where .= $outLocationId>0 ? ' and find_in_set('.$outLocationId.',a.outLocationId)' :'';
        $where .= $inLocationId>0 ? ' and find_in_set('.$inLocationId.',a.inLocationId)' :'';
        $where .= $this->get_admin_purview();
        $list = $this->get_invoice($where.' order by a.id desc limit '.$rows*($page-1).','.$rows);
        $v = [];
        foreach ($list as $arr=>$row) {
            $postData = unserialize($row['postData']);
            foreach ($postData['entries'] as $arr1=>$row1) {
                $qty[$row['id']][]             = abs($row1['qty']);
                $mainUnit[$row['id']][]        = $row1['mainUnit'];
                $goods[$row['id']][]           = $row1['invNumber'].' '.$row1['invName'].' '.$row1['invSpec'];
                $inLocationName[$row['id']][]  = $row1['inLocationName'];
                $outLocationName[$row['id']][] = $row1['outLocationName'];
            }
            $v[$arr]['id']                 = intval($row['id']);
            $v[$arr]['billDate']           = $row['billDate'];
            $v[$arr]['qty']                = $qty[$row['id']];
            $v[$arr]['goods']              = $goods[$row['id']];
            $v[$arr]['mainUnit']           = $mainUnit[$row['id']];
            $v[$arr]['description']        = $row['description'];
            $v[$arr]['billNo']             = $row['billNo'];
            $v[$arr]['userName']           = $row['userName'];
            $v[$arr]['checkName']          = $row['checkName'];
            $v[$arr]['checked']            = intval($row['checked']);
            $v[$arr]['outLocationName']    = $outLocationName[$row['id']];
            $v[$arr]['inLocationName']     = $inLocationName[$row['id']];
        }
        $json['status']                     = 'success';
        $json['msg']                        = '数据请求成功！';
        $json['data']['current_page']       = $page;
        $json['data']['total']              = $this->get_invoice($where,3);
        $json['data']['last_page']          = ceil($json['data']['total']/$rows);
        $json['data']['next_page_url']      = $page + 1 >= $json['data']['last_page'] ? null : $page + 1;
        $json['data']['data']               = isset($v) ? $v : [];
        $this->show_msg($json);
    }

    /**
     * 获取调拨信息
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_info(Request $request){
        $this->checkpurview(144);
        $data = $request->all();
        $id   = intval($data['id']);
        $data = json_decode(json_encode(DB::table('invoice')->where(['id'=>$id,'transType'=>103091,'isDelete'=>0])->first()),true);
        if (count($data)>0) {
            $postData = unserialize($data['postData']);
            $v = [];
            foreach ($postData['entries'] as $arr=>$row) {
                $v[$arr]['invId']           = intval($row['invId']);
                $v[$arr]['invNumber']       = $row['invNumber'];
                $v[$arr]['invSpec']         = $row['invSpec'];
                $v[$arr]['invName']         = $row['invName'];
                $v[$arr]['goods']           = $row['invNumber'].' '.$row['invName'].' '.$row['invSpec'];
                $v[$arr]['qty']             = (float)abs($row['qty']);
                $v[$arr]['mainUnit']        = $row['mainUnit'];
                $v[$arr]['unitId']          = intval($row['unitId']);
                $v[$arr]['inLocationId']    = $row['inLocationId'];
                $v[$arr]['inLocationName']  = $row['inLocationName'];
                $v[$arr]['outLocationId']   = $row['outLocationId'];
                $v[$arr]['outLocationName'] = $row['outLocationName'];
            }
            $json['status']                 = 'success';
            $json['msg']                    = '数据获取成功！';
            $json['data']['id']             = intval($data['id']);
            $json['data']['date']           = $data['billDate'];
            $json['data']['billNo']         = $data['billNo'];
            $json['data']['totalQty']       = (float)$data['totalQty'];
            $json['data']['description']    = $data['description'];
            $json['data']['userName']       = $data['userName'];
            $json['data']['status']         = intval($data['checked'])==1 ? 'view' : 'edit';
            $json['data']['checked']        = intval($data['checked']);
            $json['data']['checkName']      = $data['checkName'];
            $json['data']['createTime']     = $data['createTime'];
            $json['data']['modifyTime']     = $data['modifyTime'];
            $json['data']['description']    = $data['description'];
            $json['data']['entries']        = isset($v) ? $v : array();
            $this->show_msg($json);
        }
        $this->str_alert(-1,'单据不存在');
    }

    /**
     * 新增
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function add(Request $request){
        $this->checkpurview(145);
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = ['billNo','billType','transType','transTypeName','createTime', 'billDate','postData','inLocationId','outLocationId', 'description','totalQty','uid','userName','modifyTime'];
            $info = [];
            foreach($access as $v){
                if(isset($data[$v])){
                    $info[$v] = $data[$v];
                }else{
                    $info[$v] = '';
                }
            }
            DB::beginTransaction();
            try{
                $iid = DB::table('invoice')->insert($info);
                $this->invoice_info($iid,$data);
                $this->logs('新增调拨单编号：'.$info['billNo'],$request);
                $return  = ['status'=>'success','msg'=>'保存成功！','success'=>true,'data'=>['id'=>intval($iid)]];
                DB::commit();
            }catch (\Exception $e) {
                //接收异常处理并回滚
                DB::rollBack();
                $return  = ['status'=>'error','msg'=>'SQL错误！','success'=>false];
            }
        }else{
            $return = ['status'=>'error','msg'=>'提交的是空数据','success'=>false];
        }
        $this->show_msg($return);
    }

    /**
     * 修改
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function update(Request $request){
        $this->checkpurview(146);
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = ['billType','transType','transTypeName','billDate',
                'postData','inLocationId','outLocationId','uid','userName',
                'description','totalQty','modifyTime'];
            $info = [];
            foreach($access as $v){
                if(isset($data[$v])){
                    $info[$v] = $data[$v];
                }else{
                    $info[$v] = '';
                }
            }
            DB::beginTransaction();
            try{
                DB::table('invoice')->where(['id'=>$data['id']])->update($info);
                $this->invoice_info($data['id'],$data);
                $this->logs('修改调拨单编号：'.$data['billNo'],$request);
                $return  = ['status'=>'success','msg'=>'保存成功！','success'=>true,'data'=>['id'=>intval($data['id'])]];
                DB::commit();
            }catch (\Exception $e) {
                //接收异常处理并回滚
                DB::rollBack();
                $return  = ['status'=>'error','msg'=>'SQL错误！','success'=>false];
            }
        }else{
            $return = ['status'=>'error','msg'=>'参数错误','success'=>false];
        }
        $this->show_msg($return);
    }

    /**
     * 组装数据
     * @param $iid
     * @param $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function invoice_info($iid,$data) {
        $profit = $this->get_profit('and billDate<="'.date('Y-m-d').'"');
        $v = [];
        $s = [];
        foreach ($data['entries'] as $arr=>$row) {
            $price = isset($profit['inprice'][$row['invId']][$row['outLocationId']]) ? $profit['inprice'][$row['invId']][$row['outLocationId']] : 0;
            $s[$arr]['iid']             = $v[$arr]['iid']             = $iid;
            $s[$arr]['uid']             = $v[$arr]['uid']             = $data['uid'];
            $s[$arr]['billNo']          = $v[$arr]['billNo']          = $data['billNo'];
            $s[$arr]['billDate']        = $v[$arr]['billDate']        = $data['billDate'];
            $s[$arr]['invId']           = $v[$arr]['invId']           = intval($row['invId']);
            $s[$arr]['skuId']           = $v[$arr]['skuId']           = isset($row['skuId']) ? intval($row['skuId']) : -1;
            $s[$arr]['unitId']          = $v[$arr]['unitId']          = intval($row['unitId']);
            $s[$arr]['billType']        = $v[$arr]['billType']        = $data['billType'];
            $s[$arr]['description']     = $v[$arr]['description']     = isset($row['description']) ? $row['description'] : '';
            $s[$arr]['transTypeName']   = $v[$arr]['transTypeName']   = $data['transTypeName'];
            $s[$arr]['transType']       = $v[$arr]['transType']       = $data['transType'];
            $v[$arr]['locationId']      = intval($row['inLocationId']);
            $v[$arr]['qty']             = abs($row['qty']);
            $v[$arr]['price']           = $price;
            $v[$arr]['amount']          = abs($row['qty']) * $price;
            $v[$arr]['entryId']         = 1;
            $s[$arr]['locationId']      = intval($row['outLocationId']);
            $s[$arr]['qty']             = -abs($row['qty']);
            $s[$arr]['price']           = $price;
            $s[$arr]['amount']          = -abs($row['qty']) * $price;
            $s[$arr]['entryId']         = 2;
        }
        if (isset($s) && isset($v)) {
            if ($data['id']>0) {
                DB::table('invoice_info')->delete($iid);
            }
            DB::table('invoice_info')->insert($v);
            DB::table('invoice_info')->insert($s);
        }
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
        $data['id']              = isset($data['id']) ? intval($data['id']) : 0;
        $data['totalQty']        = (float)$data['totalQty'];
        $data['billType']        = 'TRANSFER';
        $data['transType']       = 103091;
        $data['transTypeName']   = '调拨单';
        $data['billDate']        = $data['date'];
        $data['description']     = $data['description'];
        $data['uid']             = $this->jxcsys['uid'];
        $data['userName']        = $this->jxcsys['name'];
        $data['modifyTime']      = date('Y-m-d H:i:s');
        $data['createTime']      = $data['modifyTime'];
        $data['accounts']        = isset($data['accounts']) ? $data['accounts'] : array();
        $data['entries']         = isset($data['entries']) ? $data['entries'] : array();

        count($data['entries']) < 1 && $this->str_alert(-1,'提交的是空数据');

        if ($data['id']>0) {
            $invoice = json_decode(json_encode(DB::table('invoice')->where(['id'=>$data['id'],'transType'=>103091,'isDelete'=>0])->first()),true);
            count($invoice)<1 && $this->str_alert(-1,'单据不存在、或者已删除');
            $data['checked'] = $invoice['checked'];
            $data['billNo']  = $invoice['billNo'];
        } else {
            $data['billNo']  = 'DB'.date("YmdHis").rand(0,9);
        }

        //商品录入验证
        $system    = $this->get_option('system');
        if ($system['requiredCheckStore']==1) {
            $inventory = $this->get_invoice_info_inventory();
        }

        $storage   = array_column(Storage::where(['disable'=>0])->get()->toArray(),'id');;
        foreach ($data['entries'] as $arr=>$row) {
            (float)$row['qty'] < 0 && $this->str_alert(-1,'商品数量要为数字，请输入有效数字！');
            intval($row['outLocationId']) < 1 && $this->str_alert(-1,'请选择调出仓库仓库！');
            intval($row['inLocationId']) < 1  && $this->str_alert(-1,'请选择调入仓库仓库！');
            intval($row['outLocationId']) == intval($row['inLocationId']) && $this->str_alert(-1,'调出仓库不能与调入仓库相同！');
            !in_array($row['outLocationId'],$storage) && $this->str_alert(-1,$row['outLocationName'].'不存在或不可用！');
            !in_array($row['inLocationId'],$storage) && $this->str_alert(-1,$row['inLocationName'].'不存在或不可用！');
            //库存判断 修改不验证
//            if ($system['requiredCheckStore']==1 && $data['id']<1) {
            if ($system['requiredCheckStore']==1) {
                if (isset($inventory[$row['invId']][$row['outLocationId']])) {
                    $inventory[$row['invId']][$row['outLocationId']] < (float)$row['qty'] && $this->str_alert(-1,$row['outLocationName'].$row['invName'].'商品库存不足！');
                } else {
                    $this->str_alert(-1,$row['invName'].'库存不足！');
                }
            }
            $inLocationId[]  = $row['inLocationId'];
            $outLocationId[] = $row['outLocationId'];
        }
        $data['inLocationId']  = join(',',array_unique($inLocationId));
        $data['outLocationId'] = join(',',array_unique($outLocationId));
        $data['postData'] = serialize($data);
        return $data;
    }
}
