<?php

namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    /**
     * 与模型关联的表名
     *
     * @var string
     */
    protected $table = 'category';
    /**
     * 重定义主键
     *
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * 可以被批量赋值的属性。
     *
     * @var array
     */
    protected $fillable = ['name','parentId','path','level','ordnum','status','typeNumber','remark','detail','sortIndex','isDelete'];
}
