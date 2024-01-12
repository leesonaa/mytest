import axios from 'axios'
import Qs from 'qs'
import {Toast} from 'vant'
const request = axios.create({
    headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest'
    },
    timeout: 60000000, // 请求超时时间
    transformRequest: [function (data) {
        data = Qs.stringify(data)
        return data
    }]
});
// response拦截器
request.interceptors.response.use(
    response => {
        /**
         * res为非0是抛错 可结合自己业务进行修改
         */
        let {success,token,msg} = response.data
        if (success) {
            return Promise.resolve(token)
        } else {
            // 写入错误信息
            Toast.fail('网络连接出错 :'+msg)
            return Promise.reject(msg)
        }
    },
    error => {
        Toast.fail('网络连接出错')
        return Promise.reject(error)
    }
)
export default request
