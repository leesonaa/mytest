<template>
    <div class="grid-content">
        <div @click="camerastart" class="titletext">扫描</div>
        <div id="barCode">结果：{{barCode}}</div>
        <div style="height:20px"></div>
        <div>
            <video id="camera" autoplay width="300" height="485"></video>
            <canvas id="canvas" width="800" height="800" hidden="hidden"></canvas>
        </div>
    </div>
</template>

<script>
export default {
    name: 'VueBarcodeTest',
    components: {
    },
    data () {
        return {
            barCode:'',
            videoobj: null,//视频对象(全局)
        }
    },
    methods: {
        //摄像头开启
        camerastart() {
            let constraints = { video: { facingMode: { exact: 'environment' }  } ,audio:false  };
            let video = document.getElementById("camera"); //video标签的对象？展示的区域？
            //获得Canvas对象
            let canvas = document.getElementById("canvas");
            let Context = canvas.getContext("2d");
            //调用摄像头
            let promise = navigator.mediaDevices.getUserMedia(constraints); //好像现在这样调用是主流方法
            promise.then(mediaStream => {
                this.videoobj =  mediaStream.getTracks();
                try {
                    video.srcObject = mediaStream;
                } catch (error) {
                    console.log(error);
                    video.src = window.URL.createObjectURL(mediaStream);
                }
                video.play();
            }).catch(err => {
                console.log(err);
            });
            //每过1秒获取一次图片
            const getimgsetInterval2 = setInterval(() => {this.takephoto(video,canvas,Context)}, 1000);
            this.$once('hook:beforeDestroy', () => {
                clearInterval(getimgsetInterval2);
            })
        },
        //拍照
        takephoto(video,canvas,Context) {
            Context.drawImage(video, 0, 0);
            // toDataURL  ---  可传入'image/png'  ---默认, 'image/jpeg'
            let imgurl = canvas.toDataURL("image/png");
            //调用识别方法
            this.analysisbarcode(imgurl);//如果img不好使，就用imgurl
        },
        //识别二维码
        analysisbarcode(imgpath) {
            this.$Quagga.decodeSingle({
                src: imgpath,
                numOfWorkers: 0,  // Needs to be 0 when used within node
                inputStream: {
                    size: 800  // restrict input-size to be 800px in width (long-side)
                },
                decoder: {
                    readers: ["code_128_reader"] // List of active readers
                },
            }, function(result) {
                if(result.codeResult) {
                    alert(result.codeResult.code);
                    //由于歪比八卜的原因，Vue的参数在这没起作用，就用原生的js先顶着
                    // document.getElementById('barCode').value = result.codeResult.code;
                } else {
                    console.log("not detected");
                }
            });
        },
    }
}
</script>
