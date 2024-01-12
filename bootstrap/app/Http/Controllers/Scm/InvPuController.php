<?php

namespace App\Http\Controllers\Scm;
use App\Http\Controllers\Controller;
use App\Http\Models\Contact;
use App\Http\Models\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InvPuController extends Controller
{

    /**
     * 审核
     * @param Request $request
     * @return void
     */
    public function batchCheckInvPu(Request $request) {
        $this->jxcsys = session('loginUser');
        $this->checkpurview(86);
        $id   = $request->post('id');
        $data = DB::table('invoice')->where(['id'=>$id,'billType'=>'PUR','checked'=>0,'isDelete'=>0])->get();
        if (count($data)>0) {
            $data = json_decode(json_encode($data),true);
            foreach($data as $arr=>$row) {
                $ids[]        = $row['id'];
                $billNo[]     = $row['billNo'];
                $srcOrderId[] = $row['srcOrderId'];
            }
            $id         = join(',',$ids);
            $billNo     = join(',',$billNo);
            $srcOrderId = join(',',array_filter($srcOrderId));
            $re = DB::table('invoice')->where('id',$id)->update(['checked'=>1,'checkName'=>$this->jxcsys['name']]);
            if ($re) {
                //$this->mysql_model->update('invoice_info',array('checked'=>1),'(iid in('.$id.'))');
                $this->logs('购货单编号：'.$billNo.'的单据已被审核！',$request);
                $this->str_alert(200,'单据编号：'.$billNo.'的单据已被审核！');
            }
            $this->str_alert(-1,'审核失败');
        }
        $this->str_alert(-1,'单据不存在！');
    }

    /**
     * 反审核
     * @param Request $request
     * @return void
     */
    public function rsBatchCheckInvPu(Request $request) {
        $this->checkpurview(87);
        $id   = $request->post('id');
        $count = DB::table('verifica_info')->where('billId',$id)->count();
        if($count > 0){
            $this->str_alert(-1,'存在关联的“付款单据”，无法删除！请先在“付款单”中删除该销货单！');
        }
        $data = DB::table('invoice')->where(['id'=>$id,'billType'=>'PUR','checked'=>1,'isDelete'=>0])->get();
        if (count($data)>0) {
            $data = json_decode(json_encode($data),true);
            foreach($data as $arr=>$row) {
                $ids[]        = $row['id'];
                $billNo[]     = $row['billNo'];
                $srcOrderId[] = $row['srcOrderId'];
            }
            $id         = join(',',$ids);
            $billNo     = join(',',$billNo);
            $srcOrderId = join(',',array_filter($srcOrderId));
            $re = DB::table('invoice')->where('id',$id)->update(['checked'=>0,'checkName'=>'']);
            if ($re) {
                //$this->mysql_model->update('invoice_info',array('checked'=>0),'(iid in('.$id.'))');
                $this->logs('购货单单号：'.$billNo.'的单据已被反审核！',$request);
                $this->str_alert(200,'购货单编号：'.$billNo.'的单据已被反审核！');
            }
            $this->str_alert(-1,'反审核失败');
        }
        $this->str_alert(-1,'单据不存在！');
    }

    /**
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function add(Request $request){
        $this->jxcsys = session()->get('loginUser');
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = ['billNo','billType','transType','transTypeName','buId','billDate','postData','hxStateCode',
                'serialno','description','totalQty','amount','arrears','rpAmount','totalAmount','createTime',
                'totalArrears','disRate','disAmount','uid','userName','srcOrderNo','srcOrderId',
                'accId','modifyTime'];
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
                $iid = DB::table('invoice')->insertGetId($info);
                $this->invoice_info($iid,$data);
                $this->account_info($iid,$data);
                $this->logs('新增购货 单据编号：'.$info['billNo'],$request);
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
     * 获取列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function list(Request $request){
        $data = $request->all();
        $this->checkpurview(1);
        $page = isset($data['page']) && $data['page'] ? $data['page'] : 1;
        $rows = isset($data['pageSize']) && $data['pageSize'] ? $data['pageSize'] : 20;
        $sidx = isset($data['sidx']) && $data['sidx'] ? $data['sidx'] : '';
        $sord = isset($data['sord']) && $data['sord'] ? $data['sord'] : 'desc';
        $matchCon  = isset($data['matchCon']) ? $this->str_enhtml($data['matchCon']) : '';
        $transType = isset($data['transType']) && $data['transType'] ? $data['transType'] : '150501';
        $beginDate = isset($data['start']) ? $this->str_enhtml($data['start']) : '';
        $endDate   = isset($data['end']) ? $this->str_enhtml($data['end']) : '';
        $order = $sidx ? $sidx.' '.$sord :' a.id desc';
        $where = 'a.isDelete=0 and a.billType="PUR"';
        $where .= $transType ? ' and a.transType='.$transType : '';
        $where .= $matchCon  ? ' and a.postData like "%'.$matchCon.'%"' : '';
        $where .= $beginDate ? ' and a.billDate>="'.$beginDate.'"' : '';
        $where .= $endDate   ? ' and a.billDate<="'.$endDate.'"' : '';
        $where .= $this->get_admin_purview();
        $list = $this->get_invoice($where.' order by '.$order.' limit '.$rows*($page-1).','.$rows);
        $v = [];
        foreach ($list as $arr=>$row) {
            $v[$arr]['hxStateCode']  = intval($row['hxStateCode']);
            $hasCheck = (float)abs($row['hasCheck']);
            if($hasCheck <= 0)
                $hxStateCode = 0;
            else if($hasCheck >= (float)abs($row['amount']))
                $hxStateCode = 2;
            else
                $hxStateCode = 1;
            $v[$arr]['hxStateCode']  = $hxStateCode;
            $v[$arr]['id']           = intval($row['id']);
            $v[$arr]['checkName']    = $row['checkName'];
            $v[$arr]['checked']      = intval($row['checked']);
            $v[$arr]['billDate']     = $row['billDate'];
            $v[$arr]['amount']       = (float)abs($row['amount']);
            $v[$arr]['transType']    = intval($row['transType']);
            $v[$arr]['rpAmount']     = (float)abs($row['hasCheck']);
            $v[$arr]['totalQty']     = (float)abs($row['totalQty']);
            $v[$arr]['contactName']  = $row['contactNo'].' '.$row['contactName'];
            $v[$arr]['serialno']     = $row['serialno'];
            $v[$arr]['description']  = $row['description'];
            $v[$arr]['billNo']       = $row['billNo'];
            $v[$arr]['totalAmount']  = (float)abs($row['totalAmount']);
            $v[$arr]['userName']     = $row['userName'];
            $v[$arr]['transTypeName']= $row['transTypeName'];
            $v[$arr]['disEditable']  = 0;
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
     * 获取采购单信息
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_info(Request $request){
        $data = $request->all();
        $this->checkpurview(1);
        $id   = intval($data['id']);
        $data =  $this->get_invoice('a.isDelete=0 and a.id='.$id.' and a.billType="PUR"',1);
        $data = reset($data);
        if (count($data)>0) {
            $info['status']                     = 'success';
            $info['msg']                        = '数据获取成功！';
            $info['data']['id']                 = intval($data['id']);
            $info['data']['buId']               = intval($data['buId']);
            $info['data']['contactName']        = $data['contactName'];
            $info['data']['date']               = $data['billDate'];
            $info['data']['billNo']             = $data['billNo'];
            $info['data']['billType']           = $data['billType'];
            $info['data']['modifyTime']         = $data['modifyTime'];
            $info['data']['createTime']         = $data['createTime'];
            $info['data']['checked']            = intval($data['checked']);
            $info['data']['checkName']          = $data['checkName'];
            $info['data']['transType']          = intval($data['transType']);
            $info['data']['totalQty']           = (float)$data['totalQty'];
            $info['data']['totalTaxAmount']     = (float)$data['totalTaxAmount'];
            $info['data']['billStatus']         = intval($data['billStatus']);
            $info['data']['disRate']            = (float)$data['disRate'];
            $info['data']['disAmount']          = (float)$data['disAmount'];
            $info['data']['amount']             = (float)abs($data['amount']);
            $info['data']['rpAmount']           = (float)abs($data['rpAmount']);
            $info['data']['arrears']            = (float)abs($data['arrears']);
            $info['data']['userName']           = $data['userName'];
            $info['data']['status']             = intval($data['checked'])==1 ? 'view' : 'edit';    //edit
            $info['data']['totalDiscount']      = (float)$data['totalDiscount'];
            $info['data']['totalTax']           = (float)$data['totalTax'];
            $info['data']['totalAmount']        = (float)abs($data['totalAmount']);
            $info['data']['serialno']        = $data['serialno'];
            $info['data']['description']        = $data['description'];
            $list = $this->get_invoice_info('a.isDelete=0 and a.iid='.$id.' order by a.id');
            foreach ($list as $arr=>$row) {
                $v[$arr]['invSpec']             = $row['invSpec'];
                $v[$arr]['srcOrderEntryId']     = $row['srcOrderEntryId'];
                $v[$arr]['srcOrderNo']          = $row['srcOrderNo'];
                $v[$arr]['srcOrderId']          = $row['srcOrderId'];
                $v[$arr]['goods']               = $row['invNumber'].' '.$row['invName'].' '.$row['invSpec'];
                $v[$arr]['invName']             = $row['invNumber'];
                $v[$arr]['barCode']             = $row['barCode'];
                $v[$arr]['qty']                 = (float)abs($row['qty']);
                $v[$arr]['amount']              = (float)abs($row['amount']);
                $v[$arr]['taxAmount']           = (float)abs($row['taxAmount']);
                $v[$arr]['price']               = (float)$row['price'];
                $v[$arr]['tax']                 = (float)$row['tax'];
                $v[$arr]['taxRate']             = (float)$row['taxRate'];
                $v[$arr]['mainUnit']            = $row['mainUnit'];
                $v[$arr]['deduction']           = (float)$row['deduction'];
                $v[$arr]['invId']               = intval($row['invId']);
                $v[$arr]['invNumber']           = $row['invNumber'];
                $v[$arr]['locationId']          = intval($row['locationId']);
                $v[$arr]['locationName']        = $row['locationName'];
                $v[$arr]['discountRate']        = $row['discountRate'];
                $v[$arr]['unitId']              = intval($row['unitId']);
                $v[$arr]['serialno']         = $row['serialno'];
                $v[$arr]['description']         = $row['description'];
                $v[$arr]['skuId']               = intval($row['skuId']);
                $v[$arr]['skuName']             = '';
            }
            $info['data']['entries']            = isset($v) ? $v : array();
            $info['data']['accId']              = (float)$data['accId'];
            $accounts = $this->get_account_info('a.isDelete=0 and a.iid='.$id.' order by a.id');
            foreach ($accounts as $arr=>$row) {
                $s[$arr]['invoiceId']           = intval($id);
                $s[$arr]['billNo']              = $row['billNo'];
                $s[$arr]['buId']                = intval($row['buId']);
                $s[$arr]['billType']            = $row['billType'];
                $s[$arr]['transType']           = $row['transType'];
                $s[$arr]['transTypeName']       = $row['transTypeName'];
                $s[$arr]['billDate']            = $row['billDate'];
                $s[$arr]['accId']               = intval($row['accId']);
                $s[$arr]['account']             = $row['accountNumber'].''.$row['accountName'];
                $s[$arr]['payment']             = (float)abs($row['payment']);
                $s[$arr]['wayId']               = (float)$row['wayId'];
                $s[$arr]['way']                 = $row['categoryName'];
                $s[$arr]['settlement']          = $row['settlement'];
            }
            $info['data']['accounts']           = isset($s) ? $s : array();
            $this->show_msg($info);
        }
        $this->str_alert(-1,'单据不存在、或者已删除');
    }

    /**
     * 修改采购单信息
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function update(Request $request){
        $this->checkpurview(3);
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = [
                'billType','transType','transTypeName','buId','billDate','hxStateCode',
                'serialno','description','totalQty','amount','arrears','rpAmount','uid','userName',
                'totalAmount','totalArrears','disRate','postData',
                'disAmount','accId','modifyTime'];
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
                DB::table('invoice')->where('id',$data['id'])->update($info);
                $this->invoice_info($data['id'],$data);
                $this->account_info($data['id'],$data);
                $this->logs('修改购货单 单据编号：'.$data['billNo'],$request);
                $return  = ['status'=>'success','msg'=>'保存成功！','success'=>true,'data'=>['id'=>intval($data['id'])]];
                DB::commit();
            }catch (\Exception $e) {
                //接收异常处理并回滚
                DB::rollBack();
                $return  = ['status'=>'error','msg'=>'SQL错误或者提交的是空数据！','success'=>false];
            }
        }else{
            $return = ['status'=>'error','msg'=>'提交的是空数据','success'=>false];
        }
        $this->show_msg($return);
    }

    /**
     * 私有方法获取采购详情
     * @param $iid
     * @param $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function invoice_info($iid,$data) {
        foreach ($data['entries'] as $arr=>$row) {
            $v[$arr]['iid']              = $iid;
            $v[$arr]['uid']              = $data['uid'];
            $v[$arr]['billNo']           = $data['billNo'];
            $v[$arr]['buId']             = $data['buId'];
            $v[$arr]['billDate']         = $data['billDate'];
            $v[$arr]['billType']         = $data['billType'];
            $v[$arr]['transType']        = $data['transType'];
            $v[$arr]['transTypeName']    = $data['transTypeName'];
            $v[$arr]['invId']            = intval($row['invId']);
            $v[$arr]['skuId']            = intval($row['skuId']);
            $v[$arr]['unitId']           = intval($row['unitId']);
            $v[$arr]['locationId']       = intval($row['locationId']);
            $v[$arr]['qty']              = $data['transType']==150501 ? abs($row['qty']) :-abs($row['qty']);
            $v[$arr]['amount']           = $data['transType']==150501 ? abs($row['amount']) :-abs($row['amount']);
            $v[$arr]['price']            = abs($row['price']);
            $v[$arr]['discountRate']     = $row['discountRate'];
            $v[$arr]['deduction']        = $row['deduction'];
            $v[$arr]['serialno']      = $row['serialno'];
            $v[$arr]['description']      = $row['description'];
            if (intval($row['srcOrderId'])>0) {
                $v[$arr]['srcOrderEntryId']  = intval($row['srcOrderEntryId']);
                $v[$arr]['srcOrderId']       = intval($row['srcOrderId']);
                $v[$arr]['srcOrderNo']       = $row['srcOrderNo'];
            } else {
                $v[$arr]['srcOrderEntryId']  = 0;
                $v[$arr]['srcOrderId']       = 0;
                $v[$arr]['srcOrderNo']       = '';
            }
        }
        if (isset($v)) {
            if ($data['id']>0) {
                DB::table('invoice_info')->where('iid',$iid)->delete();
            }
            DB::table('invoice_info')->insert($v);
        }
    }

    /**
     * 私有方法获取账户详情
     * @param $iid
     * @param $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function account_info($iid,$data) {
        foreach ($data['accounts'] as $arr=>$row) {
            $v[$arr]['iid']               = $iid;
            $v[$arr]['uid']               = $data['uid'];
            $v[$arr]['billNo']            = $data['billNo'];
            $v[$arr]['buId']              = $data['buId'];
            $v[$arr]['billType']          = $data['billType'];
            $v[$arr]['transType']         = $data['transType'];
            $v[$arr]['transTypeName']     = $data['transType']==150501 ? '普通采购' : '采购退回';
            $v[$arr]['payment']           = $data['transType']==150501 ? -abs($row['payment']) : abs($row['payment']);
            $v[$arr]['billDate']          = $data['billDate'];
            $v[$arr]['accId']             = $row['accId'];
            $v[$arr]['wayId']             = $row['wayId'];
            $v[$arr]['settlement']        = $row['settlement'];
        }
        if ($data['id']>0) {
            DB::table('account_info')->where('iid',$iid)->delete();
        }
        if (isset($v)) {
            DB::table('account_info')->insert($v);
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
        $data['billType']        = 'PUR';
        $data['transTypeName']   = $data['transType']==150501 ? '购货' : '退货';
        $data['billDate']        = $data['date'];
        $data['buId']            = intval($data['buId']);
        $data['accId']           = intval($data['accId']);
        $data['transType']       = intval($data['transType']);
        $data['amount']          = (float)$data['amount'];
        $data['arrears']         = (float)$data['arrears'];
        $data['disRate']         = (float)$data['disRate'];
        $data['disAmount']       = (float)$data['disAmount'];
        $data['rpAmount']        = (float)$data['rpAmount'];
        $data['totalQty']        = (float)$data['totalQty'];
        $data['totalArrears']    = (float)$data['totalArrears'];
        $data['accounts']        = isset($data['accounts']) ? $data['accounts'] : [];
        $data['entries']         = isset($data['entries']) ? $data['entries'] : [];
        $data['arrears'] < 0 && $this->str_alert(-1,'本次欠款要为数字，请输入有效数字！');
        $data['disRate'] < 0 && $this->str_alert(-1,'折扣率要为数字，请输入有效数字！');
        $data['rpAmount'] < 0  && $this->str_alert(-1,'本次收款要为数字，请输入有效数字！');
        $data['amount'] < $data['rpAmount']  && $this->str_alert(-1,'本次收款不能大于折后金额！');
        $data['amount'] < $data['disAmount'] && $this->str_alert(-1,'折扣额不能大于合计金额！');
        if ($data['amount']==$data['rpAmount']) {
            $data['hxStateCode'] = 2;
        } else {
            $data['hxStateCode'] = $data['rpAmount']!=0 ? 1 : 0;
        }
        $data['amount']          = $data['transType']==150501 ? abs($data['amount']) : -abs($data['amount']);
        $data['arrears']         = $data['transType']==150501 ? abs($data['arrears']) : -abs($data['arrears']);
        $data['rpAmount']        = $data['transType']==150501 ? abs($data['rpAmount']) : -abs($data['rpAmount']);
        $data['totalAmount']     = $data['transType']==150501 ? abs($data['totalAmount']) : -abs($data['totalAmount']);
        $data['uid']             = $this->jxcsys['uid'];
        $data['userName']        = $this->jxcsys['name'];
        $data['modifyTime']      = date('Y-m-d H:i:s');
        $data['createTime']      = $data['modifyTime'];
        strlen($data['billNo']) < 1 && $this->str_alert(-1,'单据编号不为空');
        count($data['entries']) < 1 && $this->str_alert(-1,'提交的是空数据');
        if ($data['id']>0) {
            //$invoice = $this->mysql_model->get_rows('invoice',array('id'=>$data['id'],'billType'=>'PUR','isDelete'=>0));
            $invoice = json_decode(json_encode(DB::table('invoice')->where(['id'=>$data['id'],'billType'=>'PUR','isDelete'=>0])->first()),true);
            count($invoice)<1 && $this->str_alert(-1,'单据不存在、或者已删除');
            $data['checked'] = $invoice['checked'];
            $data['billNo']  = $invoice['billNo'];
        } else {
            //$data['billNo']  = str_no('CG');
        }

        foreach ($data['accounts'] as $arr=>$row) {
            (float)$row['payment'] < 0 && $this->str_alert(-1,'结算金额要为数字，请输入有效数字！');
        }
        //$this->mysql_model->get_count('contact',array('id'=>$data['buId'])) < 1 && $this->str_alert(-1,'购货单位不存在');
        Contact::where(['id'=>$data['buId']])->count() < 1 && $this->str_alert(-1,'购货单位不存在');
        $system  = $this->get_option('system');
        if ($system['requiredCheckStore']==1) {
            $inventory = $this->get_invoice_info_inventory();
        }
        $storage = array_column(Storage::where(['disable'=>0])->get()->toArray(),'id');
        foreach ($data['entries'] as $arr=>$row) {
            intval($row['invId'])<1 && $this->str_alert(-1,'请选择商品');
            (float)$row['qty'] < 0  && $this->str_alert(-1,'商品数量要为数字，请输入有效数字！');
            (float)$row['price'] < 0  && $this->str_alert(-1,'商品销售单价要为数字，请输入有效数字！');
            (float)$row['discountRate'] < 0  && $this->str_alert(-1,'折扣率要为数字，请输入有效数字！');
            intval($row['locationId']) < 1 && $this->str_alert(-1,'请选择相应的仓库！');
            !in_array($row['locationId'],$storage) && $this->str_alert(-1,$row['locationName'].'不存在或不可用！');
            if ($system['requiredCheckStore']==1 && $data['id']<1) {
                if ($data['transType']==150502) {
                    if (isset($inventory[$row['invId']][$row['locationId']])) {
                        $inventory[$row['invId']][$row['locationId']] < $row['qty'] && $this->str_alert(-1,$row['locationName'].$row['invName'].'商品库存不足！');
                    } else {
                        $this->str_alert(-1,$row['invName'].'库存不足！');
                    }
                }
            }
        }
        $data['srcOrderNo'] = $data['entries'][0]['srcOrderNo'] ? $data['entries'][0]['srcOrderNo'] : 0;
        $data['srcOrderId'] = $data['entries'][0]['srcOrderId'] ? $data['entries'][0]['srcOrderId'] : 0;
        $data['postData'] = serialize($data);
        return $data;
    }
}
