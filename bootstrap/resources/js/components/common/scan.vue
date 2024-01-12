<template>
    <div class="page-scan">
        <div class="base-line" style="display: flex;align-items: center;justify-content: center;">
            <van-icon @click="toScanCode" size="30" style="font-weight:700" name="scan" />
        </div>
        <!-- 扫描盒子 -->
        <div class="scan-box" v-if="scanTextData.showScanBox">
            <div class="scan-cacel" @click="cancelScan" v-show="scanTextData.showScanBoxInfo">
                <!-- <img src="" alt=""> -->
                取消
            </div>
            <video ref="video" id="video" class="scan-video" v-show="scanTextData.showScanBoxInfo" autoplay></video>
            <div class="scan-img" v-show="scanTextData.showScanBoxInfo">
                <div class="scan-frame">
                    <span class="left-t"></span>
                    <span class="right-t"></span>
                    <span class="left-b"></span>
                    <span class="right-b"></span>
                    <span class="cross-line"></span>
                </div>
            </div>
            <!-- <img  src="/static/img/scan.svg" alt="" v-show="scanTextData.showScanBoxInfo"> -->
            <div class="scan-tip" v-show="scanTextData.showScanBoxInfo"> {{scanTextData.tipMsg}} </div>
        </div>
    </div>
</template>


<script>
import { BrowserMultiFormatReader } from '@zxing/library';
let scanTextData = {
    loadingShow: false,
    codeReader: null,
    scanText: '',
    vin: null,
    tipMsg: '将二维码置于屏幕中，即可识别',
    tipShow: false
}
export default {
    props:['dataObj'],
    name: 'scanCodePage',
    watch:{
      scanData(newVal,oldVal){
          if(!newVal){
              return false;
          }
          //检测是否有32位连续数字+字母串码
          let pa = /[0-9|A-Z]{32}/i
          let check = newVal.match(pa);
          if(check && check.length > 0){
              newVal = check[0];
          }
          this.$emit('scan',newVal);
      },
    },
    data() {
        return {
            scanData:'',
            scanTextData:{
                loadingShow: false,
                codeReader: null,
                scanText: '',
                vin: null,
                tipMsg: '将二维码置于屏幕中，即可识别',
                tipShow: false,

                showScanBox:false,
                showScanBoxInfo:false,
            },
            hasBind:false
        }
    },
    methods: {
        toScanCode(){
            console.log('识别二维码');
            this.scanData = '';
            scanTextData.codeReader = new BrowserMultiFormatReader();
            this.openScan();

        },
        cancelScan(){
            //识别完停止使用摄像头
            let thisVideo = document.getElementById("video");
            thisVideo.srcObject.getTracks()[0].stop()
            scanTextData.codeReader.reset(); // 重置
            this.scanTextData.showScanBox = false
            this.$nextTick(()=>{
                this.scanTextData.showScanBoxInfo = false;
            });
        },

        async openScan() {
            scanTextData.codeReader.getVideoInputDevices().then((videoInputDevices) => {
                scanTextData.tipShow = true;
                scanTextData.tipMsg = '正在调用摄像头...';
                console.log('videoInputDevices', videoInputDevices);
                // 默认获取第一个摄像头设备id
                let firstDeviceId = videoInputDevices[0].deviceId;
                // 获取第一个摄像头设备的名称
                const videoInputDeviceslablestr = JSON.stringify(videoInputDevices[0].label);
                if (videoInputDevices.length > 1) {
                    // 判断是否后置摄像头
                    if (videoInputDeviceslablestr.indexOf('back') > -1) {
                        firstDeviceId = videoInputDevices[0].deviceId;
                    } else {
                        firstDeviceId = videoInputDevices[1].deviceId;
                    }
                }
                this.scanTextData.showScanBox = true;
                this.decodeFromInputVideoFunc(firstDeviceId);
            }).catch(err => {
                scanTextData.tipShow = false;
                console.error(err);
            });
        },
        decodeFromInputVideoFunc(firstDeviceId) {
            scanTextData.codeReader.reset(); // 重置
            scanTextData.scanText = '';
            scanTextData.codeReader.decodeFromInputVideoDeviceContinuously(firstDeviceId, 'video', (result, err) => {
                scanTextData.tipMsg = '将二维码置于屏幕中，即可识别';
                scanTextData.scanText = '';
                this.$nextTick(()=>{
                    this.scanTextData.showScanBoxInfo = true;
                });
                if (result) {
                    //console.log('扫描结果', result.text);
                    if (result.text) {
                        //console.log('扫描结果11', result.text);
                        this.scanTextData.showScanBox = false
                        this.scanTextData.showScanBoxInfo = false
                        this.scanTextData.scanText = result.text
                        this.scanData = result.text;
                        //这里扫描出结果可以调用你想要的方法
                        //识别完停止使用摄像头
                        let thisVideo = document.getElementById("video");
                        thisVideo.srcObject.getTracks()[0].stop()
                        scanTextData.codeReader.reset(); // 重置
                    }
                }else{
                    console.log('没出来？',result,err)
                }
                if (err && !(err)) {
                    scanTextData.tipMsg = '识别失败';
                    this.$nextTick(()=>{
                        scanTextData.tipShow = false;
                    });
                    console.error(err);
                }
            });
        },

    },
}
</script>


<style scoped lang="scss">
.pullWrap{
    width:100%;
    height: 100px;
    padding-top: 50px;
    background: #fff;
    .topTitle{
        width:100%;
        position: relative;
        .pullTitle{
            display: flex;
            height: 80px;
            line-height: 80px;
            margin-top: -40px;
            background: #fff;
            align-items: center;
            justify-content: space-between;
            .pullName{
                font-size: 12px;
                color: rgba(0,0,0,0.85);
            }
            img{
                width: 40px;
                height: 40px;
            }
            .left-icon{
                margin:0 15px;
            }
            span{
                text-decoration: underline;
                text-decoration-color: #42a5ff;
                color: #42a5ff;
                margin-left: 5px;
            }
            .right-part{
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: space-around;
                border-bottom: 1px solid #e5e5e5;
                overflow: hidden;
                text-overflow: ellipsis;
                input{
                    border:none;
                    flex: 1;
                }
            }
        }
    }
}


.scan-index-bar{
    background-image: linear-gradient( -45deg, #42a5ff ,#59cfff);
}
.van-nav-bar__title{
    color: #fff !important;
}
.scan-box{
    position: fixed;
    top: 0;
    left: 0;
    z-index: 5;
    height: 100%;
    width: 100vw;
    .scan-cacel{
        position: absolute;
        top: 30px;
        left: 30px;
        z-index: 9;
        color: #fff;
        font-size: 20px;
    }
}
.scan-video{
    height: 100vh;
    width: 100vw;
    object-fit:cover;
}
.scan-img{
    width: 100%;
    height: 350px;
    position: fixed;
    top: 40%;
    //left: 50%;
    //margin-top: -200px;
    margin:-200px 0 0;
    z-index: 6;
    .scan-frame{
        width: 90%;
        height: 100%;
        margin:0 auto;
        position: relative;
        .left-t,.right-t,.left-b,.right-b{
            position: absolute;
            width: 80px;
            height: 80px;
        }
        .left-t{
            top: 0;
            left: 0;
            border-top:2px solid #17B1B7;
            border-left:2px solid #17B1B7;
        }
        .right-t{
            top: 0;
            right: 0;
            border-top:2px solid #17B1B7;
            border-right:2px solid #17B1B7;
        }
        .left-b{
            bottom: 0;
            left: 0;
            border-bottom:2px solid #17B1B7;
            border-left:2px solid #17B1B7;
        }
        .right-b{
            bottom: 0;
            right: 0;
            border-bottom:2px solid #17B1B7;
            border-right:2px solid #17B1B7;
        }
        .cross-line{
            width: 350px;
            height: 5px;
            background: linear-gradient(to right, rgba(255, 255, 255, 0),#5DDDD3,rgba(255,255,255,0));
            position: absolute;
            top: 0;
            //left: -50px;
            //margin:0 8% 0;
            animation: identifier_p 5s infinite;
        }
        @keyframes identifier_p {
            0%{
                top: 0%;
            }
            50%{
                top: 100%;
            }
            100%{
                top: 0;
            }
        }
    }
}
.scan-tip{
    width: 100vw;
    text-align: center;
    margin-bottom: 10vh;
    color: white;
    font-size: 5vw;
    position: absolute;
    bottom: 50px;
    left: 0;
}
.page-scan{
    overflow-y: hidden;
    // background-color: #363636;
}
</style>
