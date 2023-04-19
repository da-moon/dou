export const SkillSelectors = {
    selectSkills: (state) => state.skillsData.skills,
    selectSkillsError: (state) => state.skillsData.error,
    selectSkillsLoading: (state) => state.skillsData.loading,
    selectUpdateSkill: (state) => state.skillsData.skillUpdated
}