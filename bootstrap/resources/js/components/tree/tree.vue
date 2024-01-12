<template>
    <div class="tree-menu">
        <ul v-for="item in data">
            <c-tree-item :data="item" v-model="test"></c-tree-item>
        </ul>
    </div>
</template>

<script>
    import cTreeItem from './tree-item'
    export default {
        props: {
            data: {
                type: [Object, Array],
                required: true
            },
            check:{
                type:[Object]
            }
        },
        data(){
            return {
                test:{},
                isTreeRoot:true,
                radio:0,
            }
        },
        model:{
            prop:'check',
            event:'test',
        },
        components: {
            cTreeItem
        },
        mounted() {
            // var me = this;
            // setInterval(function(){
            //     console.log(me.test);
            // },1000);
        },
        // watch: {
        //     watchTest(newVal,oldVal){
        //         console.log(newVal,'<br>',oldVal);
        //         this.$emit('test',newVal);
        //     },
        // },
        computed:{
            //检测本次付款
            watchTest(){
                return this.test;
            },
        }
    }
</script>
