<?php
namespace App\Http\Controllers\Scm;
use App\Http\Controllers\Controller;
use App\Http\Models\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class InvSaController extends Controller
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * 订单审核
     * @param Request $request
     * @return void
     */
    public function checkInvSa(Request $request) {
        $this->jxcsys = session('loginUser');
        $this->checkpurview(89);
        $id   = $request->post('id');
        $data = DB::table('invoice')->where(['id'=>$id,'billType'=>'SALE','checked'=>0,'isDelete'=>0])->get();
        if (count($data)>0) {
            $data = json_decode(json_encode($data),true);
            $re = DB::table('invoice')->where('id',$id)->update(['checked'=>1,'checkName'=>$this->jxcsys['name']]);
            if ($re) {
                foreach($data as $arr=>$row) {
                    $billno[]     = $row['billNo'];
                    $srcOrderId[] = $row['srcOrderId'];
                }
                $billno     = join(',',$billno);
                $srcOrderId = join(',',$srcOrderId);
                //变更状态
                if (strlen($srcOrderId)>0) {
                    DB::table('order')->where('id',$srcOrderId)->update(['billStatus'=>2]);
                }
                $this->logs('销货单编号：'.$billno.'的单据已被审核！',$request);
                $this->str_alert(200,'销货单编号：'.$billno.'的单据已被审核！');
            }
            $this->str_alert(-1,'审核失败');
        }
        $this->str_alert(-1,'所选的单据都已被审核，请选择未审核的销货单进行审核！');
    }

    /**
     * 反审核
     * @param Request $request
     * @return void
     */
    public function revsCheckInvSa(Request $request) {
        $this->checkpurview(90);
        $id   = $request->post('id');
        $count = DB::table('verifica_info')->where('billId',$id)->count();
        if($count > 0){
           $this->str_alert(-1,'存在关联“收款单据”，无法删除！请先在“收款单”中删除该销货单！');
        }
        $data = DB::table('invoice')->where(['id'=>$id,'billType'=>'SALE','checked'=>1,'isDelete'=>0])->get();
        if (count($data)>0) {
            $data = json_decode(json_encode($data),true);
            $re = DB::table('invoice')->where('id',$id)->update(['checked'=>0,'checkName'=>'']);
            if ($re) {
                foreach($data as $arr=>$row) {
                    $billno[]     = $row['billNo'];
                    $srcOrderId[] = $row['srcOrderId'];
                }
                $billno     = join(',',$billno);
                $srcOrderId = join(',',$srcOrderId);
                //变更状态
                if (strlen($srcOrderId)>0) {
                    DB::table('order')->where('id',$srcOrderId)->update(['billStatus'=>0]);
                }
                $this->logs('销货单：'.$billno.'的单据已被反审核！',$request);
                $this->str_alert(200,'销货单编号：'.$billno.'的单据已被反审核！');
            }
            $this->str_alert(-1,'反审核失败');
        }
        $this->str_alert(-1,'所选的销货单都是未审核，请选择已审核的销货单进行反审核！');
    }

    /**
     * 获取销售单列表
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function list(Request $request){
        $session = session('loginUser');
        $uid = 0;
        if($session['roleid'] !== 0){
            $uid = $session['uid'];
        }
        $data = $request->all();
        $this->checkpurview(6);
        $page = isset($data['page']) && $data['page'] ? $data['page'] : 1;
        $rows = isset($data['pageSize']) && $data['pageSize'] ? $data['pageSize'] : 20;
        $sidx = isset($data['sidx']) && $data['sidx'] ? $data['sidx'] : '';
        $sord = isset($data['sord']) && $data['sord'] ? $data['sord'] : 'desc';
        $transType = isset($data['transType']) && $data['transType'] ? $data['transType'] : '150601';
        //$hxState   = intval($this->input->get_post('hxState',TRUE));//
        $hxState   = isset($data['hxState']) ? $this->str_enhtml($data['hxState']) : '';//
        $salesId   = isset($data['salesId']) ? intval($data['salesId']) : '';
        $matchCon  = isset($data['matchCon']) ? $this->str_enhtml($data['matchCon']) : '';
        $beginDate = isset($data['start']) ? $this->str_enhtml($data['start']) : '';
        $endDate   = isset($data['end']) ? $this->str_enhtml($data['end']) : '';
        $order = $sidx ? $sidx.' '.$sord :' a.id desc';
        $where = 'a.isDelete=0 and a.transType='.$transType;
        $where .= $salesId>0    ? ' and a.salesId='.$salesId : '';
        $where .= $uid > 0 ? ' and a.uid = '.$uid : '';
        //$where .= $hxState>0    ? ' and a.hxStateCode='.$hxState : ''; //
        if($hxState !== ''){
            if($hxState == 0)
                $where .= ' and a.rpAmount + ifnull(e.nowCheck,0) <= 0';
            else if($hxState == 1)
                $where .= ' and abs(a.rpAmount + ifnull(e.nowCheck,0))<abs(a.amount) and abs(a.rpAmount + ifnull(e.nowCheck,0))>0 ';
            else if($hxState == 2)
                $where .= ' and abs(a.rpAmount + ifnull(e.nowCheck,0)) >= abs(a.amount)';
        }
        $where .= $matchCon     ? ' and a.postData like "%'.$matchCon.'%"' : '';
        $where .= $beginDate    ? ' and a.billDate>="'.$beginDate.'"' : '';
        $where .= $endDate      ? ' and a.billDate<="'.$endDate.'"' : '';
        $where .= $this->get_admin_purview();
        $list = $this->get_invoice($where.' order by '.$order.' limit '.$rows*($page-1).','.$rows);
        $v = [];
        foreach ($list as $arr=>$row) {
            $v[$arr]['hxStateCode']  = intval($row['hxStateCode']);
            //add begin
            $hasCheck = (float)abs($row['hasCheck']);
            if($hasCheck <= 0)
                $hxStateCode = 0;
            else if($hasCheck >= (float)abs($row['amount']))
                $hxStateCode = 2;
            else
                $hxStateCode = 1;
            //add end
            $v[$arr]['hxStateCode']  = $hxStateCode;
            $v[$arr]['checkName']    = $row['checkName'];
            $v[$arr]['checked']      = intval($row['checked']);
            $v[$arr]['salesId']      = intval($row['salesId']);
            $v[$arr]['salesName']    = $row['salesName'];
            $v[$arr]['billDate']     = $row['billDate'];
            $v[$arr]['billStatus']   = $row['billStatus'];
            $v[$arr]['totalQty']     = (float)$row['totalQty'];
            $v[$arr]['id']           = intval($row['id']);
            $v[$arr]['amount']       = (float)abs($row['amount']);
            $v[$arr]['billStatusName']   = $row['billStatus']==0 ? '未出库' : '全部出库';
            $v[$arr]['transType']    = intval($row['transType']);
            $v[$arr]['rpAmount']     = (float)abs($row['hasCheck']);
            $v[$arr]['totalQty']     = (float)abs($row['totalQty']);
            $v[$arr]['contactName']  = $row['contactName'];
            $v[$arr]['serialno']     = $row['serialno'];
            $v[$arr]['description']  = $row['description'];
            $v[$arr]['billNo']       = $row['billNo'];
            $v[$arr]['totalAmount']  = (float)abs($row['totalAmount']);
            $v[$arr]['userName']     = $row['userName'];
            $v[$arr]['transTypeName']= $row['transTypeName'];
            $v[$arr]['udf01']        = $row['udf01'];
            $v[$arr]['udf02']        = $row['udf02'];
            $v[$arr]['udf03']        = $row['udf03'];
        }
        $json['status']                     = 'success';
        $json['msg']                        = '数据请求成功！';
        $json['data']['current_page']       = $page;
        $json['data']['total']               = $this->get_invoice($where,3);
        $json['data']['last_page']          = ceil($json['data']['total']/$rows);
        $json['data']['next_page_url']      = $page + 1 >= $json['data']['last_page'] ? null : $page + 1;
        $json['data']['data']               = isset($v) ? $v : array();
        $this->show_msg($json);
    }

    /**
     * 获取销售单详情
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function get_info(Request $request){
        $this->checkpurview(6);
        $data = $request->all();
        $id   = intval($data['id']);
        $data =  $this->get_invoice('a.id='.$id.' and a.billType="SALE"',1);
        $data = reset($data);
        $info = [];
        if (count($data)>0) {
            $info['status'] = 'success';
            $info['msg']    = '数据获取成功！';
            $info['data']['id']                 = intval($data['id']);
            $info['data']['buId']               = intval($data['buId']);
            $info['data']['cLevel']             = 0;
            $info['data']['contactName']        = $data['contactName'];
            $info['data']['salesId']            = intval($data['salesId']);
            $info['data']['date']               = $data['billDate'];
            $info['data']['billNo']             = $data['billNo'];
            $info['data']['billType']           = $data['billType'];
            $info['data']['transType']          = intval($data['transType']);
            $info['data']['totalQty']           = (float)$data['totalQty'];
            $info['data']['modifyTime']         = $data['modifyTime'];
            $info['data']['createTime']         = $data['createTime'];
            $info['data']['checked']            = intval($data['checked']);
            $info['data']['checkName']          = $data['checkName'];
            $info['data']['disRate']            = (float)$data['disRate'];
            $info['data']['disAmount']          = (float)$data['disAmount'];
            $info['data']['amount']             = (float)abs($data['amount']);
            $info['data']['rpAmount']           = (float)abs($data['rpAmount']);
            $info['data']['customerFree']       = (float)$data['customerFree'];
            $info['data']['arrears']            = (float)abs($data['arrears']);
            $info['data']['userName']           = $data['userName'];
            $info['data']['status']             = intval($data['checked'])==1 ? 'view' : 'edit';
            $info['data']['totalDiscount']      = (float)$data['totalDiscount'];
            $info['data']['totalAmount']        = (float)abs($data['totalAmount']);
            $info['data']['description']        = $data['description'];
            $info['data']['udf01']        = $data['udf01'];
            $info['data']['udf02']        = $data['udf02'];
            $info['data']['udf03']        = $data['udf03'];

            $list = $this->get_invoice_info('a.iid='.$id.' order by a.id');
            $arr = 0;
            foreach ($list as $arrkey=>$row) {
                if(isset($row['udf02'])&& $row['udf02'] == '1'){
                    $dopey = (array) json_decode($row['udf06'], true);
                    $v[$arr]['invSpec']           = $dopey['invSpec'];
                    $v[$arr]['taxRate']           = (float)$dopey['taxRate'];
                    $v[$arr]['srcOrderEntryId']   = intval($dopey['srcOrderEntryId']);
                    $v[$arr]['srcOrderNo']        = $dopey['srcOrderNo'];
                    $v[$arr]['srcOrderId']        = intval($dopey['srcOrderId']);
                    $v[$arr]['goods']             = $dopey['invNumber'].' '.$dopey['invName'].' '.$dopey['invSpec'];
                    $v[$arr]['invName']      = $dopey['invName'];
                    $v[$arr]['qty']          = (float)abs($dopey['qty']);
                    $v[$arr]['locationName'] = $dopey['locationName'];
                    $v[$arr]['amount']       = (float)abs($dopey['amount']);
                    $v[$arr]['taxAmount']    = (float)0;
                    $v[$arr]['price']        = (float)$dopey['price'];
                    $v[$arr]['tax']          = (float)0;
                    $v[$arr]['mainUnit']     = $dopey['mainUnit'];
                    $v[$arr]['deduction']    = (float)$dopey['deduction'];
                    $v[$arr]['invId']        = intval($dopey['invId']);
                    $v[$arr]['invNumber']    = $dopey['invNumber'];
                    $v[$arr]['locationId']   = intval($dopey['locationId']);
                    $v[$arr]['locationName'] = $dopey['locationName'];
                    $v[$arr]['discountRate'] = $dopey['discountRate'];
                    $v[$arr]['serialno']     = $dopey['serialno'];
                    $v[$arr]['description']  = $dopey['description'];
                    $v[$arr]['unitId']       = intval($dopey['unitId']);
                    $v[$arr]['mainUnit']     = $dopey['mainUnit'];
                    $v[$arr]['udf03'] = $dopey['udf03'];
                    $v[$arr]['udf04'] = $dopey['udf04'];
                    $v[$arr]['udf05'] = $dopey['udf05'];
                    $arr++;
                } else if(empty($row['udf02'])){
                    $v[$arr]['invSpec']           = $row['invSpec'];
                    $v[$arr]['taxRate']           = (float)$row['taxRate'];
                    $v[$arr]['srcOrderEntryId']   = intval($row['srcOrderEntryId']);
                    $v[$arr]['srcOrderNo']        = $row['srcOrderNo'];
                    $v[$arr]['srcOrderId']        = intval($row['srcOrderId']);
                    $v[$arr]['goods']             = $row['invNumber'].' '.$row['invName'].' '.$row['invSpec'];
                    $v[$arr]['invName']      = $row['invName'];
                    $v[$arr]['qty']          = (float)abs($row['qty']);
                    $v[$arr]['locationName'] = $row['locationName'];
                    $v[$arr]['amount']       = (float)abs($row['amount']);
                    $v[$arr]['taxAmount']    = (float)$row['taxAmount'];
                    $v[$arr]['price']        = (float)$row['price'];
                    $v[$arr]['tax']          = (float)$row['tax'];
                    $v[$arr]['barCode']     = $row['barCode'];
                    $v[$arr]['mainUnit']     = $row['mainUnit'];
                    $v[$arr]['deduction']    = (float)$row['deduction'];
                    $v[$arr]['invId']        = intval($row['invId']);
                    $v[$arr]['invNumber']    = $row['invNumber'];
                    $v[$arr]['locationId']   = intval($row['locationId']);
                    $v[$arr]['locationName'] = $row['locationName'];
                    $v[$arr]['discountRate'] = $row['discountRate'];
                    $v[$arr]['serialno']     = $row['serialno'];
                    $v[$arr]['description']  = $row['description'];
                    $v[$arr]['unitId']       = intval($row['unitId']);
                    $v[$arr]['mainUnit']     = $row['mainUnit'];
                    $v[$arr]['udf03'] = $row['udf03'];
                    $v[$arr]['udf04'] = $row['udf04'];
                    $v[$arr]['udf05'] = $row['udf05'];
                    $arr++;
                }
            }

            $info['data']['entries']     = isset($v) ? $v : array();
            $info['data']['accId']       = (float)$data['accId'];
            $accounts = $this->get_account_info('a.iid='.$id.' order by a.id');
            foreach ($accounts as $arr=>$row) {
                $s[$arr]['invoiceId']     = intval($id);
                $s[$arr]['billNo']        = $row['billNo'];
                $s[$arr]['buId']          = intval($row['buId']);
                $s[$arr]['billType']      = $row['billType'];
                $s[$arr]['transType']     = $row['transType'];
                $s[$arr]['transTypeName'] = $row['transTypeName'];
                $s[$arr]['billDate']      = $row['billDate'];
                $s[$arr]['accId']         = intval($row['accId']);
                $s[$arr]['account']       = $row['accountNumber'].' '.$row['accountName'];
                $s[$arr]['payment']       = (float)abs($row['payment']);
                $s[$arr]['wayId']         = (float)$row['wayId'];
                $s[$arr]['way']           = $row['categoryName'];
                $s[$arr]['settlement']    = $row['settlement'];
            }
            $info['data']['accounts']     = isset($s) ? $s : array();
            $this->show_msg($info);
        }
        $this->str_alert(-1,'单据不存在、或者已删除');
    }


    /**
     * 销售单新增
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function add(Request $request){
        $this->checkpurview(7);
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = [
                'billNo','billType','transType','transTypeName','buId','billDate','srcOrderNo','srcOrderId',
                'description','totalQty','amount','arrears','rpAmount','totalAmount','hxStateCode',
                'totalArrears','disRate','disAmount','postData','createTime','description',
                'salesId','uid','userName','accId','modifyTime','udf01','udf02','udf03'];
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
                $this->logs('新增销货 单据编号：'.$info['billNo'],$request);
                $return  = ['status'=>'success','msg'=>'保存成功！','success'=>true,'data'=>['id'=>intval($iid)]];
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
     * 销售单删除
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2021-12-23
     */
    public function delete(Request $request)
    {
        $this->checkpurview(9);
        $data = $request->all();
        $id   = intval($data['id']);
        $data = DB::table('invoice')->where(['id'=>$id,'billType'=>'SALE'])->first();
        DB::beginTransaction();
        if(!empty($data->id)){
            try{
                if($data->checked){
                    throw new \Exception('已审核的不可删除',-1);
                }
                DB::table('invoice')->where(['id'=>$id])->update(['isDelete'=>1]);
                DB::table('invoice_info')->where(['iid'=>$id])->update(['isDelete'=>1]);
                if ($data->accId > 0) {
                    DB::table('account_info')->where(['iid'=>$id])->update(['isDelete'=>1]);
                }
                $return = ['status'=>'success','msg'=>'删除成功！','success'=>true];
                DB::commit();
                $this->logs('删除购货订单 单据编号：'.$data->billNo,$request);
            }catch (\Exception $e) {
                $msg = 'SQL错误或者提交的是空数据！';
                if($e->getCode() === -1){
                    $msg = $e->getMessage();
                }
                //接收异常处理并回滚
                DB::rollBack();
                $return  = ['status'=>'error','msg'=>$msg,'success'=>false];
            }
        }else{
            $return = ['status'=>'error','msg'=>'单据不存在、或者已删除','success'=>false];
        }

        $this->show_msg($return);
    }

    /**
     * 销售单修改
     * @param Request $request
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    public function update(Request $request){
        $this->checkpurview(8);
        $data = $request->all();
        $data = $this->validform((array)json_decode($data['postData'], true));
        if (count($data)>0) {
            $access = [
                'billType','transType','transTypeName','buId','billDate','description','hxStateCode',
                'totalQty','amount','arrears','rpAmount','totalAmount','uid','userName',
                'totalArrears','disRate','disAmount','postData',
                'salesId','accId','modifyTime','udf01','udf02','udf03'];
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
                $this->logs('修改销货 单据编号：'.$data['billNo'],$request);
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
     * 私有方法组装数据
     * @param $iid
     * @param $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function invoice_info($iid,$data) {
        $i = 1;
        $v = [];
        foreach ($data['entries'] as $arr=>$row) {
            $v[$arr]['iid']           = $iid;
            $v[$arr]['uid']           = $data['uid'];
            $v[$arr]['billNo']        = $data['billNo'];
            $v[$arr]['billDate']      = $data['billDate'];
            $v[$arr]['buId']          = $data['buId'];
            $v[$arr]['transType']     = $data['transType'];
            $v[$arr]['transTypeName'] = $data['transTypeName'];
            $v[$arr]['billType']      = $data['billType'];
            $v[$arr]['salesId']       = $data['salesId'];
            $v[$arr]['invId']         = intval($row['invId']);
            $v[$arr]['skuId']         = isset($row['skuId']) ? intval($row['skuId']) : -1;
            $v[$arr]['unitId']        = isset($row['unitId']) ? intval($row['unitId']) : -1;
            $v[$arr]['locationId']    = intval($row['locationId']);
            $v[$arr]['qty']           = $data['transType']==150601 ? -abs($row['qty']) :abs($row['qty']);
            $v[$arr]['amount']        = $data['transType']==150601 ? abs($row['amount']) :-abs($row['amount']);
            $v[$arr]['price']         = abs($row['price']);
            $v[$arr]['discountRate']  = $row['discountRate'];
            $v[$arr]['deduction']     = $row['deduction'];
            $v[$arr]['serialno']      = $row['serialno'];
            $v[$arr]['description']   = $row['description'];
            if (intval($row['srcOrderId'])>0) {
                $v[$arr]['srcOrderEntryId']  = intval($row['srcOrderEntryId']);
                $v[$arr]['srcOrderId']       = intval($row['srcOrderId']);
                $v[$arr]['srcOrderNo']       = $row['srcOrderNo'];
            } else {
                $v[$arr]['srcOrderEntryId']  = 0;
                $v[$arr]['srcOrderId']       = 0;
                $v[$arr]['srcOrderNo']       = '';
            }
            $v[$arr]['srcDopey'] = '';
            $v[$arr]['srcDopeyName'] = '';
            $v[$arr]['udf01'] = '';
            $v[$arr]['udf02'] = '';
            $v[$arr]['udf03'] = $row['udf03'];
            $v[$arr]['udf04'] = $row['udf04'];
            $v[$arr]['udf05'] = $row['udf05'];
            $v[$arr]['udf06'] = '';
            $srcGood = $v[$arr];
            $srcGood['invName'] = $row['invName'];
            $srcGood['invNumber'] = $row['invNumber'];
            $srcGood['invSpec'] = $row['invSpec'];
            $srcGood['mainUnit'] = $row['mainUnit'];
            $srcGood['locationId'] = $row['locationId'];
            $srcGood['locationName'] = $row['locationName'];
            $udf06 = json_encode($srcGood);
            $goods = json_decode(json_encode(DB::table('goods')->whereRaw('(id = ?) and (isDelete=?)',[$row['invId'],0])->first()),true);
            if ($goods) {
                $good = $goods;//$good = $goods[0];
                if($good['dopey']==1){
                    $songoods = (array)json_decode($good['sonGoods'],true);
                    if(count($songoods)>0){
                        $j = 1;
                        foreach ($songoods as $sonarr=>$sonrow) {
                            if($j == 1){
                                $v[$arr]['invId'] = intval($sonrow['gid']);
                                $tmpqty = intval($sonrow['qty'])*intval($row['qty']);
                                $v[$arr]['qty'] = $data['transType']==150601 ? -abs($tmpqty) :abs($tmpqty);
                                $v[$arr]['price'] = intval($row['amount'])/($tmpqty);
                                $v[$arr]['amount'] = $data['transType']==150601 ? abs($row['amount']) :-abs($row['amount']);
                                $v[$arr]['srcDopey'] = $row['invNumber'];
                                $v[$arr]['srcDopeyName'] = $row['invName'];
                                $v[$arr]['udf01'] = $i;
                                $v[$arr]['udf02'] = $j;
                                $v[$arr]['udf06'] = $udf06;
                                $v[$arr]['udf03'] = $row['udf03'];
                                $v[$arr]['udf04'] = $row['udf04'];
                                $v[$arr]['udf05'] = $row['udf05'];
                            }else{
                                $v[$arr.$j]['iid']           = $iid;
                                $v[$arr.$j]['uid']           = $data['uid'];
                                $v[$arr.$j]['billNo']        = $data['billNo'];
                                $v[$arr.$j]['billDate']      = $data['billDate'];
                                $v[$arr.$j]['buId']          = $data['buId'];
                                $v[$arr.$j]['transType']     = $data['transType'];
                                $v[$arr.$j]['transTypeName'] = $data['transTypeName'];
                                $v[$arr.$j]['billType']      = $data['billType'];
                                $v[$arr.$j]['salesId']       = $data['salesId'];
                                //$v[$arr.$j]['invId']         = intval($sonrow['invId']);
                                $v[$arr.$j]['skuId']         = intval($row['skuId']);
                                $v[$arr.$j]['unitId']        = intval($row['unitId']);
                                $v[$arr.$j]['locationId']    = intval($row['locationId']);
                                //$v[$arr.$j]['qty']           = $data['transType']==150601 ? -abs($sonrow['qty']) :abs($sonrow['qty']);
                                //$v[$arr.$j]['amount']        = $data['transType']==150601 ? abs($sonrow['amount']) :-abs($sonrow['amount']);
                                // $v[$arr.$j]['price']         = abs($sonrow['price']);
                                $v[$arr.$j]['discountRate']  = $row['discountRate'];
                                $v[$arr.$j]['deduction']     = $row['deduction'];
                                $v[$arr.$j]['serialno']      = $row['serialno'];
                                $v[$arr.$j]['description']   = $row['description'];
                                if (intval($row['srcOrderId'])>0) {
                                    $v[$arr.$j]['srcOrderEntryId']  = intval($row['srcOrderEntryId']);
                                    $v[$arr.$j]['srcOrderId']       = intval($row['srcOrderId']);
                                    $v[$arr.$j]['srcOrderNo']       = $row['srcOrderNo'];
                                } else {
                                    $v[$arr.$j]['srcOrderEntryId']  = 0;
                                    $v[$arr.$j]['srcOrderId']       = 0;
                                    $v[$arr.$j]['srcOrderNo']       = '';
                                }
                                $v[$arr.$j]['invId'] = intval($sonrow['gid']);
                                $tmpqty = intval($sonrow['qty'])*intval($row['qty']);
                                $v[$arr.$j]['qty'] = $data['transType']==150601 ? -abs($tmpqty) :abs($tmpqty);
                                $v[$arr.$j]['price'] = 0;
                                $v[$arr.$j]['amount'] = 0;
                                $v[$arr.$j]['srcDopey'] = $row['invNumber'];
                                $v[$arr.$j]['srcDopeyName'] = $row['invName'];
                                $v[$arr.$j]['udf01'] = $i;
                                $v[$arr.$j]['udf02'] = $j;
                                $v[$arr.$j]['udf06'] = $udf06;
                                $v[$arr.$j]['udf03'] = $row['udf03'];
                                $v[$arr.$j]['udf04'] = $row['udf04'];
                                $v[$arr.$j]['udf05'] = $row['udf05'];
                            }
                            $j++;
                        }
                    }
                }
            }
            $i++;
        }
        if (isset($v)) {
            if ($data['id']>0) {
                DB::table('invoice_info')->where('iid',$iid)->delete();
            }
            DB::table('invoice_info')->insert($v);
        }
    }

    /**
     * 私有方法组装账户数据
     * @param $iid
     * @param $data
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function account_info($iid,$data) {
        $v = [];
        foreach ($data['accounts'] as $arr=>$row) {
            $v[$arr]['iid']           = intval($iid);
            $v[$arr]['billNo']        = $data['billNo'];
            $v[$arr]['buId']          = $data['buId'];
            $v[$arr]['billType']      = $data['billType'];
            $v[$arr]['transType']     = $data['transType'];
            $v[$arr]['transTypeName'] = $data['transType']==150601 ? '普通销售' : '销售退回';
            $v[$arr]['billDate']      = $data['billDate'];
            $v[$arr]['accId']         = $row['accId'];
            $v[$arr]['payment']       = $data['transType']==150601 ? abs($row['payment']) : -abs($row['payment']);
            $v[$arr]['wayId']         = $row['wayId'];
            $v[$arr]['settlement']    = $row['settlement'] ;
            $v[$arr]['uid']           = $data['uid'];
        }
        if ($data['id']>0) {
            DB::table('account_info')->where('iid',$iid)->delete();
        }
        if (isset($v)) {
            DB::table('account_info')->insert($v);
        }
    }


    /**
     * 私有方法公共验证
     * @param $data
     * @return mixed
     * @author : zl
     * @email : 932460566@qq.com
     * @date : 2020-07-18
     */
    private function validform($data) {
        $data['id']              = isset($data['id']) ? intval($data['id']) : 0;
        $data['buId']            = intval($data['buId']);
        $data['accId']           = intval($data['accId']);
        $data['salesId']         = intval($data['salesId']);
        $data['transType']       = intval($data['transType']);
        $data['amount']          = (float)$data['amount'];
        $data['arrears']         = (float)$data['arrears'];
        $data['disRate']         = (float)$data['disRate'];
        $data['disAmount']       = (float)$data['disAmount'];
        $data['rpAmount']        = (float)$data['rpAmount'];
        $data['totalQty']        = (float)$data['totalQty'];
        $data['totalArrears']    = isset($data['totalArrears']) ?(float)$data['totalArrears']:0;
        $data['totalDiscount']   = isset($data['totalDiscount']) ? (float)$data['totalDiscount']:0;
        $data['customerFree']    = isset($data['customerFree']) ? (float)$data['customerFree']:0;
        $data['billType']        = 'SALE';
        $data['billDate']        = $data['date'];
        $data['transTypeName']   = $data['transType']==150601 ? '销货' : '销退';
        $data['serialno']        = isset($data['serialno']) ? $data['serialno'] : '';
        $data['description']     = isset($data['description']) ? $data['description'] : '';
        $data['totalTax']        = isset($data['totalTax']) ? (float)$data['totalTax'] :0;
        $data['totalTaxAmount']  = isset($data['totalTaxAmount']) ? (float)$data['totalTaxAmount'] :0;

        $data['arrears'] < 0 && $this->str_alert(-1,'本次欠款要为数字，请输入有效数字！');
        $data['disRate'] < 0 && $this->str_alert(-1,'折扣率要为数字，请输入有效数字！');
        $data['rpAmount'] < 0  && $this->str_alert(-1,'本次收款要为数字，请输入有效数字！');
        $data['customerFree'] < 0 && $this->str_alert(-1,'客户承担费用要为数字，请输入有效数字！');
        $data['amount'] < $data['rpAmount'] + (int)$data['customerFree']  && $this->str_alert(-1,'本次收款不能大于折后金额！');
        $data['amount'] < $data['disAmount'] && $this->str_alert(-1,'折扣额不能大于合计金额！');
        if ($data['amount']==$data['rpAmount']) {
            $data['hxStateCode'] = 2;
        } else {
            $data['hxStateCode'] = $data['rpAmount']!=0 ? 1 : 0;
        }
        $data['amount']          = $data['transType']==150601 ? abs($data['amount']) : -abs($data['amount']);
        $data['arrears']         = $data['transType']==150601 ? abs($data['arrears']) : -abs($data['arrears']);
        $data['rpAmount']        = $data['transType']==150601 ? abs($data['rpAmount']) : -abs($data['rpAmount']);
        $data['totalAmount']     = $data['transType']==150601 ? abs($data['totalAmount']) : -abs($data['totalAmount']);
        $data['uid']             = $this->jxcsys['uid'];
        $data['userName']        = $this->jxcsys['name'];
        $data['modifyTime']      = date('Y-m-d H:i:s');
        $data['createTime']      = $data['modifyTime'];
        $data['accounts']        = isset($data['accounts']) ? $data['accounts'] : array();
        $data['entries']         = isset($data['entries']) ? $data['entries'] : array();

        count($data['entries']) < 1 && $this->str_alert(-1,'提交的是空数据');


        //选择了结算账户 需要验证
        foreach ($data['accounts'] as $arr=>$row) {
            (float)$row['payment'] < 0 && $this->str_alert(-1,'结算金额要为数字，请输入有效数字！');
        }

        if ($data['id']>0) {
            $invoice = json_decode(json_encode(DB::table('invoice')->where(['id'=>$data['id'],'billType'=>'SALE','isDelete'=>0])->first()),true);
            count($invoice)<1 && $this->str_alert(-1,'单据不存在、或者已删除');
            $data['checked'] = $invoice['checked'];
            $data['billNo']  = $invoice['billNo'];
        } else {
            //$data['billNo']  = str_no('XS');
        }

        //供应商验证
        DB::table('contact')->where(['id'=>$data['buId']])->count() <1 && $this->str_alert(-1,'客户不存在');

        //商品录入验证
        $system  = $this->get_option('system');

        //库存验证
        if ($system['requiredCheckStore']==1) {
            $inventory = $this->get_invoice_info_inventory();
        }
        if($system['requiredCheckStore']==1 && $data['id']>=1){
            if (intval($data['transType'])==150601) {
                $lastdata = $this->get_invoice('a.id='.$data['id'].' and a.billType="SALE"',1)[0];
                $postData = unserialize($lastdata['postData']);
                $newData = [];
                foreach ($postData['entries'] as $arr=>$row) {
                    if(!isset($newData[$row['invId']][$row['locationId']])){
                        $newData[$row['invId']][$row['locationId']] = 0;
                    }
                    $newData[$row['invId']][$row['locationId']] += (float)$row['qty'];
                }
            }
        }
        $storage   = array_column(Storage::where(['disable'=>0])->get()->toArray(),'id');
        foreach ($data['entries'] as $arr=>$row) {
            intval($row['invId'])<1 && $this->str_alert(-1,'请选择商品');
            (float)$row['qty'] < 0 && $this->str_alert(-1,'商品数量要为数字，请输入有效数字！');
            (float)$row['price'] < 0 && $this->str_alert(-1,'商品销售单价要为数字，请输入有效数字！');
            (float)$row['discountRate'] < 0 && $this->str_alert(-1,'折扣率要为数字，请输入有效数字！');
            intval($row['locationId']) < 1 && $this->str_alert(-1,'请选择相应的仓库！');
            !in_array($row['locationId'],$storage) && $this->str_alert(-1,$row['locationName'].'不存在或不可用！');
            //库存判断 修改不验证
            if ($system['requiredCheckStore']==1 && $data['id']<1) {
                if (intval($data['transType'])==150601) {                        //销售才验证
                    if (isset($inventory[$row['invId']][$row['locationId']])) {

                        $inventory[$row['invId']][$row['locationId']] < $row['qty'] && $this->str_alert(-1,$row['locationName'].$row['invName'].'商品库存不足！');
                    } else {
                        //str_alert(-1,$row['invName'].'库存不足！');
                        //组合品库存检查
                        $gooddata = DB::table('goods')->whereRaw('(id =?) and (isDelete=?)',[$row['invId'],0])->first();
                        if($gooddata){
                            $dopey = json_decode(json_encode($gooddata),true);
                            if($dopey['dopey'] != 1){
                                $this->str_alert(-1,'商品'.$row['invName'].'库存不足！');
                            }else{
                                $sonlist = (array)json_decode($dopey['sonGoods'],true) ;
                                if(count($sonlist)>0){
                                    foreach ($sonlist as $sonkey=> $sonrow){
                                        if($inventory[$sonrow['gid']][$row['locationId']] < $row['qty']*$sonrow['qty'])
                                            $this->str_alert(-1,'商品“'.$row['invName'].'”的子商品“'.$sonrow['name'].'”库存不足！');
                                    }
                                }else{
                                    $this->str_alert(-1,'商品“'.$row['invName'].'”的子商品丢失，请检查！');
                                }
                            }
                        }else{
                            $this->str_alert(-1,'商品“'.$row['invName'].'”不存在！');
                        }
                    }
                }
            }else if($system['requiredCheckStore']==1 && $data['id']>=1){
                //修改时库存验证
                if (isset($inventory[$row['invId']][$row['locationId']])) {
                    if(isset($newData[$row['invId']][$row['locationId']])){
                        $inventory[$row['invId']][$row['locationId']] < ($row['qty']-$newData[$row['invId']][$row['locationId']]) && $this->str_alert(-1,$row['locationName'].$row['invName'].'商品库存不足！');
                    }
                }else {
                    $gooddata = DB::table('goods')->whereRaw('(id =?) and (isDelete=?)',[$row['invId'],0])->first();
                    if($gooddata){
                        $this->str_alert(-1,'商品'.$row['invName'].'库存不足！');
                    }else{
                        $this->str_alert(-1,'商品“'.$row['invName'].'”不存在！');
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
