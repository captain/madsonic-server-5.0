<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
	<script type="text/javascript" src="/script/jquery-migrate-1.1.1.js"></script>
    <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/playlistService.js"/>"></script>	
	
    <script type="text/javascript" language="javascript">
    $(function() {
    $( "#dialog-confirm" ).dialog({
      resizable: false,
      height:140,
      modal: true,
      buttons: {
        "Delete all items": function() {
          $( this ).dialog( "close" );
        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      }
    });
  });
  </script>
	
    <script type="text/javascript" language="javascript">

	    var playlist;
		var playlists;

	    window.onload = init;
		
        function init() {
            dwr.engine.setErrorHandler(null);
            updatePlaylists();
        }

        function updatePlaylists() {
            playlistService.getReadablePlaylists(playlistCallback);
        }

        function createNamedPlaylist(loadPlaylistUrl) {
		
			var isShared = false;
		    if ($("#isShared").is(":checked")) {
                isShared = true;
            }
			var playlistName = $("#playlistName").val();
			var playlistComment = $("#playlistComment").val();

		//	alert("Playlist '" + playlistName + "' created");
            playlistService.createNamedPlaylist(playlistName, playlistComment, isShared);
			
			updatePlaylists();
			location.href = loadPlaylistUrl;
		}

        function createEmptyPlaylist(loadPlaylistUrl) {
			var isShared = false;
		    if ($("#isShared").is(":checked")) {
                isShared = true;
            }
			var playlistComment = $("#playlistComment").val();
            playlistService.createEmptyPlaylist(playlistComment, isShared, playlistCallback);
			top.left.updatePlaylists();
			location.href = loadPlaylistUrl;
		}

		function CreateAndRefresh() {
			createEmptyPlaylist();
			location.href = "loadPlaylist.view";
		}
		
        function createEmptyPlaylist() {
            playlistService.createEmptyPlaylist(playlistCallback);
	//		$("#playlists").show();
	//		updatePlaylists();
	//		location.href = "loadPlaylist.view";
		}
		
        function onPlayAll(playlistId) {
            top.playQueue.onPlayPlaylist(playlistId);
        }

        function onAddAll(playlistId) {
            top.playQueue.onPlayPlaylist(playlistId);
        }
		
        function playlistCallback(playlists) {
            this.playlists = playlists;
        }		

		function confirmAction(onSuccessFunction, functionArg) 	{
			var message = "<fmt:message key="playlist.load.confirm_delete"/>";
			$('#confirmDialog').html(message);
			$('#confirmDialog').dialog({
				modal: true,
				autoOpen: false,
				title: 'Confirm',
				width: 320,
				height: 150,
				buttons: {
					'Yes': function() {
						$(this).dialog('close');
						onSuccessFunction(functionArg);
					},
					'No': function() {
						$(this).dialog('close');
					}
				}
			});
			$("#confirmDialog").dialog('open');
			
		};

		function onDeletePlaylist(deleteUrl) {
			location.href = deleteUrl;
		}
    </script>
</head>
<body class="mainframe bgcolor1">
<div id="confirmDialog"></div>

<h1>
    <c:choose>
        <c:when test="${model.load}">
            <fmt:message key="playlist.load.title"/>
        </c:when>
        <c:otherwise>
            <fmt:message key="playlist.load.appendtitle"/>
        </c:otherwise>
    </c:choose>
</h1>

<!--
	<table>
    <tr>
        <th align="left" style="padding-top:1em">Name</th>
        <th align="left" style="padding-top:1em">Comment</th>
		<th align="left" style="padding-top:1em">Public</th>
    </tr>

    <tr class="dense">
        <td><input type="text" id="playlistName" name="playlistName" value="Your Playlist" size="40"/></td>
        <td><input type="text" id="playlistComment" name="playlistComment" value="" size="40"/></td>
        <td align="center" style="padding-left:1em"><input id="isShared" name="isShared" type="checkbox" class="checkbox"/></td>
        <td/>
    </tr>	
	</table>
	-->
<!--	<p>
	<div><a href="javascript:noop()" onclick="CreateAndRefresh()"><fmt:message key="left.createplaylist"/></a></div>

	<div id="playlistWrapper" style='padding-left:0.5em'>

<!--		<sub:url value="loadPlaylist.view" var="loadPlaylistUrl"></sub:url>
		<div class="forward"><a href="javascript:noop()" onclick="createNamedPlaylist('${loadPlaylistUrl}')"><fmt:message key="playlist.load.createNamedplaylist"/></a></div>
		
		<sub:url value="loadPlaylist.view" var="loadPlaylistUrl"></sub:url>
		<div class="forward"><a href="javascript:noop()" onclick="createEmptyPlaylist('${loadPlaylistUrl}')"><fmt:message key="playlist.load.createEmptyplaylist"/></a></div>
		<div class="forward"><a href="importPlaylist.view" target="main"><fmt:message key="left.importplaylist"/></a></div>
-->		
<!--
		<p></p>
		<div class="forward"><a href="loadPlaylist.view?"><fmt:message key="common.refresh"/></a></div>
	</div>
</p>-->

	<div id="playlists"></div>
	
<c:choose>

    <c:when test="${empty model.playlists}">
        <p class="warning"><fmt:message key="playlist.load.empty"/></p>
    </c:when>
    <c:otherwise>
        <table class="ruleTable indent">
            <c:forEach items="${model.playlists}" var="playlist">
                <sub:url value="loadPlaylistConfirm.view" var="loadUrl">
				<sub:param name="id" value="${playlist.id}"/></sub:url>
				
                <sub:url value="deletePlaylist.view" var="deleteUrl"><sub:param name="id" value="${playlist.id}"/></sub:url>
                <sub:url value="download.view" var="downloadUrl"><sub:param name="playlist" value="${playlist.id}"/></sub:url>
                <sub:url value="playlist.view" var="editUrl"><sub:param name="id" value="${playlist.id}"/></sub:url>
                <tr>
				
						<td style="padding-left:12px;padding-right:12px;">
						<c:if test="${playlist.shareLevel eq '0'}">
							<img src="icons/default/playlist-private.png" title="Private Playlist" width="32" height="32" />
						</c:if>
							
						<c:if test="${playlist.shareLevel eq '1'}">
							<img src="icons/default/playlist-group.png" title="Public Playlist" width="32" height="32" />
						</c:if>
						
						<c:if test="${playlist.shareLevel eq '2'}">
							<img src="icons/default/playlist-add.png" title="Add Allowed Playlist" width="32" height="32" />
						</c:if>

						<c:if test="${playlist.shareLevel eq '3'}">
							<img src="icons/default/playlist-utilities.png" title="Remove Allowed Playlist" width="32" height="32" />
						</c:if>

						<c:if test="${playlist.shareLevel eq '4'}">
							<img src="icons/default/playlist-unlocked.png" title="Full Access Playlist" width="32" height="32" />
						</c:if>
						
						
						</td>
						
                    <td class="ruleTableHeaderPlaylists" style='border-top: 1px dashed #8B8B8B;border-bottom: 1px dashed #8B8B8B;padding-right:1em'>${playlist.name}</td>
                    <td class="ruleTableHeaderPlaylists" style='border-top: 1px dashed #8B8B8B;border-bottom: 1px dashed #8B8B8B;padding-right:1em'>${playlist.comment}</td>
					<td class="ruleTableHeaderPlaylists" style='border-top: 1px dashed #8B8B8B;border-bottom: 1px dashed #8B8B8B;padding-right:1em'>[${playlist.username}]</td>
                    <td align="center" class="ruleTableHeaderPlaylists" style='border-top: 1px dashed #8B8B8B;border-bottom: 1px dashed #8B8B8B;padding-right:1em'>[${playlist.fileCount}]</td>
                    <td class="ruleTableCellPlaylists" style="border-top: 1px dashed #8B8B8B;border-bottom: 1px dashed #8B8B8B;padding-right:1em;">
					<Table>
					<tr>
						<td>
							<div class="forward"><a href="javascript:void(0)" onclick="onPlayAll(${playlist.id});">Play</a></div>
						</td>
						<!--
						<td>
							<div class="forward"><a href="javascript:void(0)" onclick="onAddAll(${playlist.id});">Add</a></div>
						</td>
						-->
						<td>
							<div class="forward"><a href="${loadUrl}"><fmt:message key="playlist.load.load"/></a></div>
						</td>
						<td>
							<div class="forward"><a href="${editUrl}">Edit</a></div>
						</td>
						<c:if test="${model.user.downloadRole}">
						<td>
							<div class="forward"><a href="${downloadUrl}"><fmt:message key="common.download"/></a></div>
						</td>
						
						</c:if>
						<c:if test="${model.user.playlistRole}">
						<td>
							<div class="forward"><a href="javascript:void(0)" onClick="javascript:confirmAction(onDeletePlaylist,'${deleteUrl}');">Delete</a></div>
						</td>
						</c:if>
					</tr>
					</table>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

</body></html>