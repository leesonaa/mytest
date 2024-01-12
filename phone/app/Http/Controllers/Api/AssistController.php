<?php
/**
 *  Assist.php
 *  Create On 2021/9/7
 *  Create by zl
 */
namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AssistController extends Controller
{
    public function get_list(Request $request){
        $data = $request->all();
        $typeNumber   = $this->str_enhtml($data['typeNumber']);
        $skey   = $this->str_enhtml(($data['skey'] ?? ''));
        $where  = '(isDelete=0) and typeNumber="'.$typeNumber.'"';
        $where .= $skey ? ' and name like "%'.$skey.'%"' : '';
        $where = [['isDelete','=',0],['typeNumber','=',$typeNumber]];
        if(!empty($skey)){
            $where[] = ['name','like','%'.$skey.'%'];
        }
        $list = DB::table('category')->where($where)->orderBy('path')->paginate($data['pageSize'])->toArray();
        $parentId  = array_column($list['data'], 'parentId');
        foreach ($list['data'] as &$row) {
            $row->detail        = !in_array($row->id, $parentId);
            $row->id            = intval($row->id);
            $row->parentId      = intval($row->parentId);
            $row->sortIndex     = intval($row->sortIndex);
            $row->status        = intval($row->isDelete);
        }
        $this->str_alert(200,'success',$list);
    }
}
