<?php
/**
 *  库存管理
 *  InvOiController.php
 *  Create On 2021/9/8
 *  Create by 932460566@qq.com
 */
namespace App\Http\Controllers\Scm;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class InvOiController extends Controller
{

    /**
     * 新增其他出库单
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function outAdd(Request $request)
    {
        $this->checkpurview(19);
        $data = $request->all();
        $data = $this->Oi_validform($data,true);
        $info = $this->formatParams(['billNo','billType','transType','transTypeName','buId','createTime',
            'billDate','description','totalQty','totalAmount','outLocationId',
            'uid','userName','modifyTime','postData'],$data);
        try{
            DB::beginTransaction();
            $iid = DB::table('invoice')->insertGetId($info);
            $this->Oi_invoice_info($iid,$data);
            if (empty($iid)) {
                DB::rollBack();
                $this->str_alert(-1,'SQL错误回滚');
            }
            DB::commit();
            $this->logs('新增其他出库 单据编号：'.$data['billNo'],$request);
            $this->str_alert(200,'success',['id'=>intval($iid)]);
        }catch (\Throwable $e){
            DB::rollBack();
        }
        $this->str_alert(-1,'提交的是空数据');
    }

    /**
     * 编辑其他出库单
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function outEdit(Request $request)
    {
        $data = $request->all();
        $this->checkpurview(20);
        $data = $this->Oi_validform($data,true);
        $info = $this->formatParams(['transType','transTypeName','buId','postData','outLocationId','uid','userName',
            'billDate','description','totalQty','totalAmount','modifyTime'],$data);
        try{
            DB::beginTransaction();
            DB::table('invoice')->where('id',$data['id'])->update($info);
            $this->Oi_invoice_info($data['id'],$data);
            DB::commit();
            $this->logs('修改其他出库 单据编号：'.$data['billNo'],$request);
            $this->str_alert(200,'success',['id'=>$data['id']]);
        }catch (\Throwable $e){
            DB::rollBack();
        }
        $this->str_alert(-1,'提交的是空数据');
    }

    /**
     * 获取其他出库详情
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function outInfo(Request $request)
    {
        $post = $request->all();
        $this->checkpurview(18);
        $id   = intval($post['id'] ?? 0);
        $data = $this->get_invoice('a.isDelete=0 and a.id='.$id.' and a.billType="OO"',1);
        if (count($data)>0) {
            $list = $this->get_invoice_info('a.isDelete=0 and a.iid='.$id.'  order by a.id desc');
            $data = $data[0];
            foreach ($list as $arr=>$row) {
                $v[$arr]['invSpec']      = $row['invSpec'];
                $v[$arr]['goods']        = $row['invNumber'].' '.$row['invName'].' '.$row['invSpec'];
                $v[$arr]['invName']      = $row['invName'];
                $v[$arr]['qty']          = (float)abs($row['qty']);
                $v[$arr]['amount']       = round(floor((float)abs($row['amount'])));
                $v[$arr]['price']        = round(floor((float)$row['price']));
                $v[$arr]['mainUnit']     = $row['mainUnit'];
                $v[$arr]['description']  = $row['description'];
                $v[$arr]['invId']        = intval($row['invId']);
                $v[$arr]['invNumber']    = $row['invNumber'];
                $v[$arr]['locationId']   = intval($row['locationId']);
                $v[$arr]['locationName'] = $row['locationName'];
                $v[$arr]['unitId']       = intval($row['unitId']);
                $v[$arr]['skuId']        = intval($row['skuId']);
                $v[$arr]['skuName']      = '';
            }
            $json['status']              = 200;
            $json['msg']                 = 'success';
            $json['data']['id']          = intval($data['id']);
            $json['data']['buId']        = intval($data['buId']);
            $json['data']['contactName'] = $data['contactName'];
            $json['data']['date']        = $data['billDate'];
            $json['data']['billNo']      = $data['billNo'];
            $json['data']['billType']    = $data['billType'];
            $json['data']['modifyTime']  = $data['modifyTime'];
            $json['data']['createTime']  = $data['createTime'];
            $json['data']['transType']   = intval($data['transType']);
            $json['data']['totalQty']    = (float)$data['totalQty'];
            $json['data']['totalAmount'] = round(floor((float)abs($data['totalAmount'])),2);
            $json['data']['userName']    = $data['userName'];
            $json['data']['description'] = $data['description'];
            $json['data']['amount']      = round(floor((float)abs($data['totalAmount'])),2);
            $json['data']['checked']     = intval($data['checked']);
            $json['data']['status']      = intval($data['checked'])==1 ? 'view' : 'edit';
            $json['data']['entries']     = isset($v) ? $v : array();
            $this->show_msg($json);
        }
        $this->str_alert(-1,'单据不存在');
    }

    /**
     * 获取其他出库列表
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function outList(Request $request)
    {
        $this->checkpurview(18);
        $data = $request->all();
        $page =  $data['page'] ?? 1;
        $rows = $data['size'] ?? 10;
        $matchCon  = isset($data['matchCon']) ? $this->str_enhtml($data['matchCon']) : '';
        $transTypeId = isset($data['transType']) && $data['transType'] ? $data['transType'] : '150806';
        $beginDate = isset($data['start']) ? $this->str_enhtml($data['start']) : '';
        $endDate   = isset($data['end']) ? $this->str_enhtml($data['end']) : '';
        $locationId   = intval($data['locationId'] ?? 0);
        $where = 'a.isDelete=0 and a.billType="OO"';
        $where .= $matchCon  ? ' and a.postData like "%'.$matchCon.'%"' : '';
        $where .= $beginDate ? ' and a.billDate>="'.$beginDate.'"' : '';
        $where .= $endDate ? ' and a.billDate<="'.$endDate.'"' : '';
        $where .= $transTypeId>0 ? ' and a.transType='.$transTypeId.'' : '';
        $where .= $locationId>0 ? ' and find_in_set('.$locationId.',outLocationId)' : '';
        $where .= $this->get_admin_purview();
        $list = $this->get_invoice($where.' order by id desc limit '.$rows*($page-1).','.$rows);
        foreach ($list as $arr=>$row) {
            $v[$arr]['checkName']    = $row['checkName'];
            $v[$arr]['checked']      = intval($row['checked']);
            $v[$arr]['billDate']     = $row['billDate'];
            $v[$arr]['billType']     = $row['billType'];
            $v[$arr]['id']           = intval($row['id']);
            $v[$arr]['amount']       = (float)abs($row['totalAmount']);
            $v[$arr]['transType']    = intval($row['transType']);;
            $v[$arr]['contactName']  = $row['contactName'];
            $v[$arr]['description']  = $row['description'];
            $v[$arr]['billNo']       = $row['billNo'];
            $v[$arr]['totalAmount']  = (float)abs($row['totalAmount']);
            $v[$arr]['userName']     = $row['userName'];
            $v[$arr]['transTypeName']= $row['transTypeName'];
        }
        $json['status']                     = 200;
        $json['msg']                        = 'success';
        $json['data']['page']               = $page;
        $json['data']['records']            = $this->get_invoice($where,3);
        $json['data']['total']              = ceil($json['data']['records']/$rows);
        $json['data']['last_page']          = ceil($json['data']['total']/$rows);
        $json['data']['next_page_url']      = $page + 1 >= $json['data']['last_page'] ? null : $page + 1;
        $json['data']['rows']               = $v ?? [];
        $this->show_msg($json);
    }

    /**
     * 获取其他入库列表
     * @param Request $request
     * @author 932460566@qq.com
     * @return void
     */
    public function list(Request $request)
    {
        $this->checkpurview(14);
        $data = $request->all();
        $page =  $data['page'] ?? 1;
        $rows = $data['size'] ?? 10;
        $matchCon  = isset($data['matchCon']) ? $this->str_enhtml($data['matchCon']) : '';
        $transTypeId = isset($data['transType']) && $data['transType'] ? $data['transType'] : '150706';
        $beginDate = isset($data['start']) ? $this->str_enhtml($data['start']) : '';
        $endDate   = isset($data['end']) ? $this->str_enhtml($data['end']) : '';
        $locationId   = intval($data['locationId'] ?? 0);
        $where = '(a.isDelete=0) and a.billType="OI"';
        $where .= $matchCon     ? ' and a.postData like "%'.$matchCon.'%"' : '';
        $where .= $beginDate ? ' and a.billDate>="'.$beginDate.'"' : '';
        $where .= $endDate ? ' and a.billDate<="'.$endDate.'"' : '';
        $where .= $transTypeId>0 ? ' and a.transType='.$transTypeId.'' : '';
        $where .= $locationId>0 ? ' and find_in_set('.$locationId.',inLocationId)' : '';
        $where .= $this->get_admin_purview();
        $list = $this->get_invoice($where.' order by id desc limit '.$rows*($page-1).','.$rows);
        foreach ($list as $arr=>$row) {
            $v[$arr]['checkName']    = $row['checkName'];
            $v[$arr]['checked']      = intval($row['checked']);
            $v[$arr]['billDate']     = $row['billDate'];
            $v[$arr]['billType']     = $row['billType'];
            $v[$arr]['id']           = intval($row['id']);
            $v[$arr]['amount']       = (float)abs($row['totalAmount']);
            $v[$arr]['transType']    = intval($row['transType']);;
            $v[$arr]['contactName']  = $row['contactName'];
            $v[$arr]['description']  = $row['description'];
            $v[$arr]['billNo']       = $row['billNo'];
            $v[$arr]['totalAmount']  = (float)abs($row['totalAmount']);
            $v[$arr]['userName']     = $row['userName'];
            $v[$arr]['transTypeName']= $row['transTypeName'];
        }
        $json['status']                     = 200;
        $json['msg']                        = 'success';
        $json['data']['page']               = $page;
        $json['data']['records']            = $this->get_invoice($where,3);
        $json['data']['total']              = ceil($json['data']['records']/$rows);
        $json['data']['last_page']          = ceil($json['data']['total']/$rows);
        $json['data']['next_page_url']      = $page + 1 >= $json['data']['last_page'] ? null : $page + 1;
        $json['data']['rows']               = $v ?? [];
        $this->show_msg($json);
    }

    /**
     * 获取其他入库单详情
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function info(Request $request)
    {
        $post = $request->all();
        $this->checkpurview(14);
        $id   = intval($post['id'] ?? 0);
        $data = $this->get_invoice('a.isDelete=0 and a.id='.$id.' and a.billType="OI"',1);
        if (count($data)>0) {
            $data = $data[0];
            $list = $this->get_invoice_info('a.isDelete=0 and a.iid='.$id.'  order by a.id desc');
            foreach ($list as $arr=>$row) {
                $v[$arr]['invSpec']      = $row['invSpec'];
                $v[$arr]['goods']        = $row['invNumber'].' '.$row['invName'].' '.$row['invSpec'];
                $v[$arr]['invName']      = $row['invName'];
                $v[$arr]['qty']          = (float)abs($row['qty']);
                $v[$arr]['amount']       = (float)abs($row['amount']);
                $v[$arr]['price']        = (float)abs($row['price']);
                $v[$arr]['mainUnit']     = $row['mainUnit'];
                $v[$arr]['description']  = $row['description'];
                $v[$arr]['invId']        = intval($row['invId']);
                $v[$arr]['invNumber']    = $row['invNumber'];
                $v[$arr]['locationId']   = intval($row['locationId']);
                $v[$arr]['locationName'] = $row['locationName'];
                $v[$arr]['unitId']       = intval($row['unitId']);
                $v[$arr]['skuId']        = intval($row['skuId']);
                $v[$arr]['skuName']      = '';
            }
            $json['status']              = 200;
            $json['msg']                 = 'success';
            $json['data']['id']          = intval($data['id']);
            $json['data']['buId']        = intval($data['buId']);
            $json['data']['contactName'] = $data['contactName'];
            $json['data']['date']        = $data['billDate'];
            $json['data']['billNo']      = $data['billNo'];
            $json['data']['billType']    = $data['billType'];
            $json['data']['modifyTime']  = $data['modifyTime'];
            $json['data']['createTime']  = $data['createTime'];
            $json['data']['transType']   = intval($data['transType']);
            $json['data']['totalQty']    = (float)$data['totalQty'];
            $json['data']['totalAmount'] = (float)$data['totalAmount'];
            $json['data']['userName']    = $data['userName'];
            $json['data']['description'] = $data['description'];
            $json['data']['amount']      = (float)abs($data['totalAmount']);
            $json['data']['checked']     = intval($data['checked']);
            $json['data']['status']      = intval($data['checked'])==1 ? 'view' : 'edit';
            $json['data']['entries']     = $v ?? [];
            $this->show_msg($json);
        }
        $this->str_alert(-1,'提交的是空数据');
    }

    /**
     * 其他入库新增
     * @author 932460566@qq.com
     * @return void
     */
    public function add(Request $request)
    {
        $this->checkpurview(15);
        $data = $request->all();
        $data = $this->Oi_validform($data);
        $info = $this->formatParams([
            'billNo','billType','transType','transTypeName','buId','inLocationId',
            'billDate','description','totalQty','totalAmount','postData','createTime',
            'uid','userName','modifyTime'],$data);
        try{
            DB::beginTransaction();
            $iid = DB::table('invoice')->insertGetId($info);
            $this->Oi_invoice_info($iid,$data);
            if (empty($iid)) {
                DB::rollBack();
                $this->str_alert(-1,'SQL错误回滚');
            }
            DB::commit();
            $this->logs('新增其他入库 单据编号：'.$data['billNo'],$request);
            $this->str_alert(200,'success',array('id'=>intval($iid)));
        }catch (\Throwable $e){
            DB::rollBack();
        }
        $this->str_alert(-1,'提交的是空数据');
    }

    /**
     * 其他入库修改
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function edit(Request $request)
    {
        $data = $request->all();
        $this->checkpurview(16);
        $data = $this->Oi_validform($data);
        $info = $this->formatParams([
            'transType','transTypeName','buId','postData','inLocationId','uid','userName',
            'billDate','description','totalQty','totalAmount','modifyTime'],$data);
        try{
            DB::beginTransaction();
            DB::table('invoice')->where('id',$data['id'])->update($info);
            $this->Oi_invoice_info($data['id'],$data);
            DB::commit();
            $this->logs('修改其他入库 单据编号：'.$data['billNo'],$request);
            $this->str_alert(200,'success',['id'=>$data['id']]);
        }catch (\Throwable $e){
            DB::rollBack();
        }
        $this->str_alert(-1,'提交的是空数据');
    }

    /**
     * 写入详情
     * @author 932460566@qq.com
     * @param $iid
     * @param $data
     * @return void
     */
    private function Oi_invoice_info($iid,$data) {
        foreach ($data['entries'] as $arr=>$row) {
            $v[$arr]['iid']           = $iid;
            $v[$arr]['billNo']        = $data['billNo'];
            $v[$arr]['buId']          = $data['buId'];
            $v[$arr]['transType']     = $data['transType'];
            $v[$arr]['transTypeName'] = $data['transTypeName'];
            $v[$arr]['billDate']      = $data['billDate'];
            $v[$arr]['billType']      = $data['billType'];
            $v[$arr]['invId']         = intval($row['invId']);
            $v[$arr]['skuId']         = intval($row['skuId']);
            $v[$arr]['unitId']        = intval($row['unitId']);
            $v[$arr]['locationId']    = intval($row['locationId']);
            $v[$arr]['qty']           = abs($row['qty']);
            $v[$arr]['amount']        = abs($row['amount']);
            $v[$arr]['price']         = abs($row['price']);
            $v[$arr]['description']   = $row['description'];
        }
        if (isset($v)) {
            if ($data['id']>0) {
                DB::table('invoice_info')->where('iid',$data['id'])->delete();
            }
            DB::table('invoice_info')->insert($v);
        }
    }

    /**
     * 获取库存信息
     * @author 932460566@qq.com
     * @param Request $request
     * @return void
     */
    public function get_ware_data(Request $request)
    {
        $this->checkpurview(11);
        $data = $request->all();
        $page = $data['page'] ?? 1;
        $size = $data['pageSize'] ?? 20;
        $showZero   = !empty($data['showZero']) ? ($data['showZero'] == 'true' ? 1 : 0) : 0;
        $categoryId = $data['categoryId'] ?? 0;
        $locationId = $data['locationId']  ?? 0;
        $goods = $this->str_enhtml(($data['goods'] ?? ''));
        $where = '(a.isDelete=0)';
        $where .= strlen($goods)>0 ? ' and (b.name like "%'.$goods.'%" or b.barCode = '.$goods.')' : '';
        $where .= $locationId>0 ? ' and a.locationId='.$locationId : '';
        if ($categoryId > 0) {
            $cid = array_column(DB::table('category')->whereRaw('(1=1) and find_in_set('.$categoryId.',path)')->get()->toArray(),'id');
            if (count($cid)>0) {
                $cid = join(',',$cid);
                $where .= ' and b.categoryId in('.$cid.')';
            }
        }
        $where .= $this->get_location_purview();
        $having = $showZero == 1 ? ' HAVING qty=0' : '';
        $list = $this->get_inventory($where.' GROUP BY a.invId,a.locationId '.$having.' limit '.$size*($page-1).','.$size);
        foreach ($list as $arr=>$row) {
            $v[$arr]['assistName']    = $row['categoryName'];
            $v[$arr]['barCode']       = $row['barCode'];
            $v[$arr]['invSpec']       = $row['invSpec'];
            $v[$arr]['locationId']    = $locationId > 0 ? intval($row['locationId']) : 0;
            $v[$arr]['skuName']       = '';
            $v[$arr]['qty']           = (float)$row['qty'];
            $v[$arr]['locationName']  = $row['locationName'];
            $v[$arr]['assistId']      = 0;
            $v[$arr]['invCost']       = 0;
            $v[$arr]['unitName']      = $row['unitName'];
            $v[$arr]['skuId']         = 0;
            $v[$arr]['invId']         = intval($row['invId']);
            $v[$arr]['invNumber']     = $row['invNumber'];
            $v[$arr]['invName']       = $row['invName'];
        }
        $json['msg']    = 'success';
        $json['data']['page']         = $page;
        $json['data']['records']      = $this->get_inventory($where.' GROUP BY a.invId,a.locationId'.$having,3)[0]['num'] ?? 0;
        $json['data']['total']        = ceil($json['data']['records']/$size);
        $json['data']['data']         = isset($v) ? $v : array();
        $this->str_alert(200,'获取成功',$json['data']);
    }

    /**
     * 检测参数
     * @author 932460566@qq.com
     * @param $data
     * @param $isOut
     * @return mixed
     */
    private function Oi_validform($data,$isOut = false) {
        $data['id']              = isset($data['id']) ? intval($data['id']) : 0;
        $data['buId']            = intval($data['buId']);
        $data['transType']       = intval($data['transTypeId']);
        $data['totalQty']        = (float)$data['totalQty'];
        $data['billType']        = $isOut ? 'OO' : 'OI';
        $data['billDate']        = $data['date'];
        $data['uid']             = $this->jxcsys['uid'];
        $data['userName']        = $this->jxcsys['name'];
        $data['modifyTime']      = date('Y-m-d H:i:s');
        $data['createTime']      = $data['modifyTime'];
        $data['accounts']        = isset($data['accounts']) ? $data['accounts'] : array();
        $data['entries']         = isset($data['entries']) ? $data['entries'] : array();

        count($data['entries']) < 1 && $this->str_alert(-1,'提交的是空数据');

        if ($data['id']>0) {
            $invoice = DB::table('invoice')->where(['id'=>$data['id'],'billType'=>$isOut ? 'OO' : 'OI','isDelete'=>0])->first();
            if(empty($invoice)){
                $this->str_alert(-1,'单据不存在、或者已删除');
            }
            $data['checked'] = $invoice->checked;
            $data['billNo']  = $invoice->billNo;
        }


        $system    = $this->get_option('system');
        if ($system['requiredCheckStore']==1) {
            $inventory = $this->get_invoice_info_inventory();
        }
        $storage = DB::table('storage')->where('disable',0)->get()->toArray();
        $storage = array_column($storage,'id');
        foreach ($data['entries'] as $arr=>$row) {
            intval($row['invId']) < 1 && str_alert(-1,'请选择商品');
            (float)$row['qty'] < 0  && str_alert(-1,'商品数量要为数字，请输入有效数字！');
            (float)$row['price'] < 0  && str_alert(-1,'商品销售单价要为数字，请输入有效数字！');
            intval($row['locationId']) < 1 && str_alert(-1,'请选择相应的仓库！');
            !in_array($row['locationId'],$storage) && str_alert(-1,$row['locationName'].'不存在或不可用！');


            if ($system['requiredCheckStore']==1 && $data['id']<1) {
                if (intval($data['transType'])==150806) {                        //其他出库才验证
                    if (isset($inventory[$row['invId']][$row['locationId']])) {
                        $inventory[$row['invId']][$row['locationId']] < (float)$row['qty'] && str_alert(-1,$row['locationName'].$row['invName'].'商品库存不足！');
                    } else {
                        str_alert(-1,$row['invName'].'库存不足！');
                    }
                }
            }
            if ($data['transType']==150706) {
                $inLocationId[]  = $row['locationId'];
            } else {
                $outLocationId[] = $row['locationId'];
            }
        }
        if ($data['transType']==150706) {
            $data['inLocationId']  = join(',',array_unique($inLocationId));
        } else {
            $data['outLocationId'] = join(',',array_unique($outLocationId));
        }
        $data['postData'] = serialize($data);
        return $data;
    }
}
