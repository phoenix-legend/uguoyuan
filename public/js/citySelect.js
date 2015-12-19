/**
 * Created by Lance on 2015/5/18.
 */
$(function(){
    $('#cityLst h3').each(function(index,ele){
        $(this).attr('id',$(this).text());
    })
    $('#lettersLst a').bind('click',function(){
        var letter = $(this).text();
        $("html,body").stop(true,false).animate({scrollTop:$('#'+letter).offset().top},1000);
    })
})