--テンペスト・オブ・ファイア
--Tempest Fire
--scripted by Larry126
function c511600202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511600202.target)
	e1:SetOperation(c511600202.activate)
	c:RegisterEffect(e1)
end
function c511600202.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c511600202.cfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c511600202.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg,atk=Duel.GetMatchingGroup(c511600202.filter,tp,LOCATION_MZONE,0,nil,e):GetMinGroup(Card.GetAttack)
	if chkc then return tg and tg:IsContains(chkc) end
	if chk==0 then return tg and tg:IsExists(Card.IsCanBeEffectTarget,1,nil,e)
		and Duel.IsExistingMatchingCard(c511600202.cfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=tg:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(tc)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg+Duel.GetMatchingGroup(c511600202.cfilter,tp,0,LOCATION_MZONE,nil,atk),#dg+1,PLAYER_ALL,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,tc:GetFirst():GetTextAttack())
end
function c511600202.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetTextAttack()
	local dg=Duel.GetMatchingGroup(c511600202.cfilter,tp,0,LOCATION_MZONE,nil,atk)
	if Duel.Destroy(Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil),REASON_EFFECT)>0
		and Duel.Damage(tp,atk,REASON_EFFECT,true) and Duel.Damage(1-tp,atk,REASON_EFFECT,true) then
		Duel.RDComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c511600202.cfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if #og>0 then
				Duel.Damage(1-tp,og:GetFirst():GetPreviousAttackOnField()/2,REASON_EFFECT)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e1,tp)
	end
end