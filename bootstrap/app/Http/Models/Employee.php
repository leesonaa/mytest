<?php

namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    //
    /**
     * 与模型关联的表名
     *
     * @var string
     */
    protected $table = 'staff';
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
    protected $fillable = ['name','number','disable','allowsms','birthday','commissionrate','creatorId','deptId','description','email','empId','empType','fullId','leftDate','mobile','parentId','sex','userName','isDelete'];
}
