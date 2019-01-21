import React from 'react';
import { propType } from 'graphql-anywhere';
import PropTypes from 'prop-types';
import moment from 'moment';

import emptyOrTipsFragment from 'react/pages/profile/ProfilePage/components/EmptyMessageOrComponent/fragments/emptyOrTips';

import ProfileEmptyMessage from 'react/components/ProfileEmptyMessage';
import ProfileTips from 'react/components/ProfileTips';

const EmptyMessageOrComponent = ({
  count: sectionCount,
  children,
  identifiable,
  ...rest
}) => {
  const createdAtDaysAgo = moment().diff(moment(identifiable.created_at), 'days');
  const isMyProfile = identifiable.is_me || identifiable.is_current_user_a_member;
  const isRecentAccount = createdAtDaysAgo <= 7;
  const isSectionEmpty = sectionCount <= 0;
  const isGroupProfile = identifiable.__typename === 'Group';

  const components = [];

  if (isMyProfile && isRecentAccount && !isGroupProfile) {
    components.push(<ProfileTips key="profileTips" isEmpty={isSectionEmpty} />);
  }

  if (isSectionEmpty) {
    const profileEmptyMessage = (
      <ProfileEmptyMessage
        key="profileEmptyMessage"
        isMine={isMyProfile}
        identifiable={identifiable}
        {...rest}
      />
    );
    components.push(profileEmptyMessage);
  }

  if (!isSectionEmpty) {
    components.push(children);
  }

  return components;
};

EmptyMessageOrComponent.propTypes = {
  count: PropTypes.number.isRequired,
  children: PropTypes.node.isRequired,
  identifiable: propType(emptyOrTipsFragment).isRequired,
};

export default EmptyMessageOrComponent;
