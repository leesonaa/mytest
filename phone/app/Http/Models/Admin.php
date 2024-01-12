<?php

namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Admin extends Model
{
    //
    /**
     * 与模型关联的表名
     *
     * @var string
     */
    protected $table = 'admin';
    /**
     * 重定义主键
     *
     * @var string
     */
    protected $primaryKey = 'uid';

    /**
     * 可以被批量赋值的属性。
     *
     * @var array
     */
    protected $fillable = ['username','userpwd','status','name','mobile','lever','roleid'];
}
