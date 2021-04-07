	function [ c, ceq ] = funcon(theta)
%
%	FUNCON: Define the constraints used in fmincon function in efrit.m
%
%	--- Japanese ---
%	efrit.m “à‚Ì fmincon function ‚Å—p‚¢‚é§–ñðŒ‚Ì’è‹`D
%
%	Copyright (C) 2009-2010 Kenichi Tasaka, Manabu Kano, Morimasa Ogawa.
%	All rights reserved. 
%	–{ƒvƒƒOƒ‰ƒ€‚¨‚æ‚Ñ–{ƒvƒƒOƒ‰ƒ€‚ð•ÏX‚µ‚½ƒvƒƒOƒ‰ƒ€‚ÌÄ”z•z‚ð‹Ö‚¶‚Ü‚·D
%

%
% --- nonlinear inequality constraints ---
%
		c = [];			% no constraints
%
% --- nonlinear equality constraints ---
%
		ceq = [];		% no constraints
		